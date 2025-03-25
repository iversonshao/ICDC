`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input clk;
input reset;
output reg [13:0] gray_addr;
output reg gray_req;
input gray_ready;
input [7:0] gray_data;
output reg [13:0] lbp_addr;
output reg lbp_valid;
output reg [7:0] lbp_data;
output reg finish;
//====================================================================
reg [2:0] state, next_state;
reg [6:0] x, y;
reg [3:0] counter;

// Pre-calculate coordinates
wire [6:0] x_b, x_f, y_b, y_f;
assign x_b = x - 7'd1;
assign x_f = x + 7'd1;
assign y_b = y - 7'd1;
assign y_f = y + 7'd1;

// Pre-calculate addresses
wire [13:0] g0_addr, g1_addr, g2_addr, g3_addr, g4_addr, g5_addr, g6_addr, g7_addr;
reg [13:0] gc_addr;

assign g0_addr = {y_b, x_b}; // top-left
assign g1_addr = {y_b, x};   // top
assign g2_addr = {y_b, x_f}; // top-right
assign g3_addr = {y, x_b};   // left
assign g4_addr = {y, x_f};   // right
assign g5_addr = {y_f, x_b}; // bottom-left
assign g6_addr = {y_f, x};   // bottom
assign g7_addr = {y_f, x_f}; // bottom-right

// Store center pixel value
reg [7:0] gc_data;

// For processing calculation
wire [3:0] counter_minus_one;
assign counter_minus_one = counter - 4'd1;

// FSM states
parameter IDLE = 3'd0;
parameter READ_CENTER = 3'd1;
parameter READ_NEIGHBORS = 3'd2;
parameter RESULT = 3'd3;
parameter FINISH = 3'd4;

// State transition
always@(posedge clk or posedge reset) begin
    if(reset) state <= IDLE;
    else state <= next_state;
end

// Next state logic
always@(*) begin
    case(state)
        IDLE: begin
            if(gray_ready) next_state = READ_CENTER;
            else next_state = IDLE;
        end
        READ_CENTER: next_state = READ_NEIGHBORS;
        READ_NEIGHBORS: begin
            if(counter == 4'd8) next_state = RESULT;
            else next_state = READ_NEIGHBORS;
        end
        RESULT: begin
            if(gc_addr == 14'd16254) next_state = FINISH; // Last pixel (127,127)
            else next_state = READ_CENTER;
        end
        FINISH: next_state = FINISH;
        default: next_state = IDLE;
    endcase
end

// Update coordinates
always@(posedge clk or posedge reset) begin
    if(reset) begin
        x <= 7'd1;
        y <= 7'd1;
    end
    else if(next_state == RESULT && x == 7'd126) begin
        x <= 7'd1;
        y <= y + 7'd1;
    end
    else if(next_state == RESULT) begin
        x <= x + 7'd1;
    end
end

// Counter for reading neighbors
always@(posedge clk or posedge reset) begin
    if(reset) counter <= 4'd0;
    else if(next_state == READ_NEIGHBORS) counter <= counter + 4'd1;
    else if(state == RESULT) counter <= 4'd0;
end

// Center address update
always@(posedge clk or posedge reset) begin
    if(reset) gc_addr <= 14'd129; // Initial center at (1,1)
    else if(next_state == READ_CENTER) gc_addr <= {y, x};
end

// gray_req control
always@(posedge clk or posedge reset) begin
    if(reset) gray_req <= 1'b0;
    else if(next_state == READ_CENTER || next_state == READ_NEIGHBORS) gray_req <= 1'b1;
    else gray_req <= 1'b0;
end

// lbp_valid control
always@(posedge clk or posedge reset) begin
    if(reset) lbp_valid <= 1'b0;
    else if(next_state == RESULT) lbp_valid <= 1'b1;
    else lbp_valid <= 1'b0;
end

// finish signal
always@(posedge clk or posedge reset) begin
    if(reset) finish <= 1'b0;
    else if(state == FINISH) finish <= 1'b1;
end

// gray_addr update for reading pixels
always@(posedge clk or posedge reset) begin
    if(reset) gray_addr <= 14'd0;
    else if(next_state == READ_CENTER) gray_addr <= {y, x};
    else if(next_state == READ_NEIGHBORS) begin
        case(counter)
            4'd0: gray_addr <= g0_addr;
            4'd1: gray_addr <= g1_addr;
            4'd2: gray_addr <= g2_addr;
            4'd3: gray_addr <= g3_addr;
            4'd4: gray_addr <= g4_addr;
            4'd5: gray_addr <= g5_addr;
            4'd6: gray_addr <= g6_addr;
            4'd7: gray_addr <= g7_addr;
            default: gray_addr <= 14'd0;
        endcase
    end
end

// lbp_addr update for writing result
always@(posedge clk or posedge reset) begin
    if(reset) lbp_addr <= 14'd0;
    else if(next_state == RESULT) lbp_addr <= gc_addr;
end

// LBP data calculation and center pixel storage
always@(posedge clk or posedge reset) begin
    if(reset) begin
        lbp_data <= 8'd0;
        gc_data <= 8'd0;
    end
    else if(state == READ_CENTER) begin
        gc_data <= gray_data; // Store center pixel value
        lbp_data <= 8'd0;    // Reset LBP value for new calculation
    end
    else if(state == READ_NEIGHBORS) begin
        if(counter > 4'd0 && gray_data >= gc_data) begin
            // Set the corresponding bit in LBP value
            lbp_data <= lbp_data | (8'd1 << counter_minus_one);
        end
    end
end

//====================================================================
endmodule
