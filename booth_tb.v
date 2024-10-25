`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2024 11:35:13 AM
// Design Name: 
// Module Name: booth_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for the Booth multiplier.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module booth_tb;
    reg clk, rst;
    reg [7:0] a, b;
    wire [15:0] product; 
    wire [2:0] block;
     // Declare product as a wire to observe the output

    // Instantiate the Booth multiplier
    booth uut(.clk(clk), .rst(rst), .a(a), .b(b), .product(product), .block(block));

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        a = 8'd2;
        b = 8'd5  ;

        // Apply reset
        #10 rst = 0; 

        // Allow some time for multiplication
        #100;
        #5 rst = 1;
        #10 rst =0;
        

        // Change inputs after some cycles
        a = 8'd5; 
        b = 8'd5; 
        

        // Wait for multiplication to complete
        #100;
        #10 rst = 1;
        #10 rst =0;
        
        a = 8'd2; 
        b = 8'd6;
        #100;
        #10 rst = 1;
        #10 rst =0;
        a = 8'd7; 
        b = 8'd5; 
        #100; 
 // Adjust time to wait for the next multiplication

        // End the simulation
        $finish;
    end

    // Clock generation
    always #5 clk = ~clk;
    //always #40 rst = ~rst;

    // Display the product
    always @(posedge clk) begin
        if (!rst) begin
            $display("At time %t: a = %d, b = %d, product = %d", $time, a, b, product);
        end
    end

endmodule
