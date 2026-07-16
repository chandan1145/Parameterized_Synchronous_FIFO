// Module: sync_fifo
// Description: Parameterized Synchronous FIFO Memory Block
module sync_fifo #(
    parameter DATA_WIDTH = 8,   // Width of each data packet
    parameter FIFO_DEPTH = 16   // Number of memory slots (Must be a power of 2)
)(
    input  wire                  clk,       // Global Clock signal
    input  wire                  rst_n,     // Active Low Asynchronous Reset
    input  wire                  wr_en,     // Write Enable control flag
    input  wire                  rd_en,     // Read Enable control flag
    input  wire [DATA_WIDTH-1:0] data_in,   // Inbound parallel data bus
    output reg  [DATA_WIDTH-1:0] data_out,  // Outbound parallel data bus
    output wire                  full,      // Status flag: Internal memory is filled
    output wire                  empty      // Status flag: Internal memory is drained
);

    // Calculate pointer bit-width dynamically using base-2 logarithm ($clog2(16) = 4 bits)
    // We add 1 extra bit (MSB) to help distinguish between Full and Empty states.
    localparam PTR_WIDTH = $clog2(FIFO_DEPTH);

    // Allocate the physical internal memory grid array (16 rows x 8 columns)
    reg [DATA_WIDTH-1:0] fifo_matrix [0:FIFO_DEPTH-1];

    // Tracking registers for internal read/write location pointer tracks
    reg [PTR_WIDTH:0] wr_ptr;
    reg [PTR_WIDTH:0] rd_ptr;

    // --- STATUS FLAG GENERATION LOGIC ---
    // Empty condition: Binary write pointer matches the read pointer exactly.
    assign empty = (wr_ptr == rd_ptr);
    
    // Full condition: Lower pointer index bits match, but the MSB phase bit is inverted.
    assign full  = (wr_ptr[PTR_WIDTH-1:0] == rd_ptr[PTR_WIDTH-1:0]) && 
                   (wr_ptr[PTR_WIDTH] != rd_ptr[PTR_WIDTH]);

    // --- SEQUENTIAL CIRCUIT CONTROLS ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear pointer positions and data output on an active system reset
            wr_ptr   <= 0;
            rd_ptr   <= 0;
            data_out <= 0;
        end else begin
            // WRITE OPERATION HANDLING BLOCK
            if (wr_en && !full) begin
                fifo_matrix[wr_ptr[PTR_WIDTH-1:0]] <= data_in; // Push data packet into array
                wr_ptr <= wr_ptr + 1;                         // Increment write address pointer
            end
            
            // READ OPERATION HANDLING BLOCK
            if (rd_en && !empty) begin
                data_out <= fifo_matrix[rd_ptr[PTR_WIDTH-1:0]]; // Pull data packet out from array
                rd_ptr   <= rd_ptr + 1;                         // Increment read address pointer
            end
        end
    end

endmodule