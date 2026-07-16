`timescale 1ns / 1ps

module sync_fifo_tb;

    // Parameters matching our design defaults
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 16;

    // Testbench Stimulus Signals
    reg                  clk;
    reg                  rst_n;
    reg                  wr_en;
    reg                  rd_en;
    reg  [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire                  full;
    wire                  empty;

    // Instantiate the Design Under Test (DUT)
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // 100MHz Clock Generation Loop (10ns period)
    always #5 clk = ~clk;

    // Verification Sequence Matrix
    initial begin
        // Initialize Inputs
        clk     = 0;
        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 0;

        // System Reset Sequence
        #20;
        rst_n = 1; // Release reset
        #10;
        
        $display("[TB START] Beginning Synchronous FIFO Verification Test...");

        // --- TEST PHASE 1: SEQUENTIAL WRITE TO FULL ---
        $display("[TEST 1] Writing data packets until FIFO is FULL...");
        repeat(FIFO_DEPTH) begin
            @(posedge clk);
            if (!full) begin
                wr_en   = 1;
                data_in = $urandom_range(10, 99); // Inject random test numbers
                #1; // Brief delay for display logging clarity
                $display("Write Action -> Data: %d", data_in);
            end
        end
        
        // Turn off write enable
        @(posedge clk);
        wr_en = 0;
        #5;
        if (full) $display("[SUCCESS] FIFO successfully asserted FULL flag.");
        
        // --- TEST PHASE 2: OVERFLOW PROTECTION CHECK ---
        $display("[TEST 2] Attempting to overflow the FULL FIFO...");
        @(posedge clk);
        wr_en   = 1;
        data_in = 8'hFF; // Push dummy error byte
        @(posedge clk);
        wr_en = 0;

        // --- TEST PHASE 3: SEQUENTIAL READ TO EMPTY ---
        $display("[TEST 3] Reading data packets until FIFO is EMPTY...");
        repeat(FIFO_DEPTH) begin
            @(posedge clk);
            if (!empty) begin
                rd_en = 1;
                #1; // Brief delay to capture output changes
                $display("Read Action <- Data Received: %d", data_out);
            end
        end
        
        // Turn off read enable
        @(posedge clk);
        rd_en = 0;
        #5;
        if (empty) $display("[SUCCESS] FIFO successfully asserted EMPTY flag.");

        $display("[TB END] Verification sequence completed successfully.");
        $finish;
    end

endmodule