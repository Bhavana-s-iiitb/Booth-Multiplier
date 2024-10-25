`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2024 11:24:05 AM
// Design Name: Booth Multiplier
// Module Name: booth
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implements Booth's algorithm for multiplication of two 8-bit numbers.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module booth (
    input clk,
    input rst,
    input [7:0] a, b,
    output reg [15:0] product, output reg [2:0] block
);

reg [15:0] pp;          // Partial product
reg [9:0] temp;         // Temporary register for b with an additional bit for shifting
        // Block for Booth's encoding
reg [1:0] shift_cnt;    // Shift counter
reg [2:0] state;        // State for controlling the multiplication process

// Initialize
always @(posedge clk or posedge rst) begin
    if (rst) begin
        product <= 0;
        temp <= {b[7:0], 1'b0};  // Load b into temp with an additional bit
        pp <= 0;
        shift_cnt <= 0;
        state <= 0;
    end
    else 
      begin
        case (state)
            0: begin
                // Prepare for multiplication
                product <= 0; // Reset product for new multiplication
                temp <= {b, 1'b0}; // Load b with an additional bit for shifting
                pp <= 0; // Reset partial product
                shift_cnt <= 0; // Reset shift count
                state <= 1; // Move to the next state
            end
            1: begin
                // Generate block based on the last 3 bits of temp
                block <= temp[2:0];
                // Encode based on Booth's algorithm
                
//                case (block)
//                    3'b000: product <= product ;          // 0
//                    3'b001: product <= product + (a<<shift_cnt);         // +a
//                    3'b010: product <= product + (a<<shift_cnt);          // +a
//                    3'b011: product <= product + (a<<(shift_cnt+1));     // +2a
//                    3'b100: product <= product - (a<<(shift_cnt+1));    // -2a
//                    3'b101: product <= product - (a<<shift_cnt);     // -a
//                    3'b110: pp <= a ;          // -a
//                    3'b111: pp <= 0;          // 0
//                    default: pp <= 0;
//                endcase
                
                case (block)
                    3'b000: pp <= 0;          // 0
                    3'b001: pp <= a;          // +a
                    3'b010: pp <= a;          // +a
                    3'b011: pp <= a << 1;     // +2a
                    3'b100: pp <= a <<1 ;     // -2a
                    3'b101: pp <= a ;     // -a
                    3'b110: pp <= a ;          // -a
                    3'b111: pp <= 0;          // 0
                    default: pp <= 0;
                endcase
               // Update product and shift
               
               if(block == 3'b100 || block == 3'b101 || block == 3'b110)
               begin
                product <= product - (pp<<shift_cnt);
                shift_cnt <= shift_cnt + 2;
                end
                
                    else begin
                product <= product + (pp<<shift_cnt); // Accumulate product
                temp <= temp >> 2; // Shift temp right by 2
                shift_cnt <= shift_cnt + 2;
                
                end // Increment shift count
                
                // Transition state or continue multiplying
                if (shift_cnt == 3) begin // Assuming 4 steps for 8 bits
                    state <= 0; // Reset state after completion
                end
            end
        endcase
    end
end

endmodule
