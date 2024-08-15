module drv_key(
    //Inputs
    input clk,
    input rst_n,
    input key,
    
    //Outputs
    output flag_press,
    output flag_release
);

//parameter 
parameter KEY_PRESS   = 1'b0;       //按键按下有效
parameter FILTER_TIME = 27_000_0;   //按键消抖时间

//localparam 
localparam KEY_RELEASE = !KEY_PRESS;
localparam S0_IDLE = 0;
localparam S1_KEY_PRESS = 1;
localparam S2_KEY_RELEASE = 2;

//reg
reg [31:0] cnt_press;
reg [31:0] cnt_release;
reg [4:0] key_sreg;       //shift reg
reg [3:0] fsm;
reg en;

wire key_is_press   = (key_sreg[4:1] == {4{KEY_PRESS}});
wire key_is_release = (key_sreg[4:1] == {4{KEY_RELEASE}});
wire key_is_shake   = !(key_is_press || key_is_release);

//assign
assign flag_press   = (fsm == S1_KEY_PRESS);
assign flag_release = (fsm == S2_KEY_RELEASE);

//always 
//按键边沿捕获移位寄存器
always @ (posedge clk) begin
    if(!rst_n) begin
        key_sreg <= {5{KEY_RELEASE}};
    end
    else begin
        key_sreg <= key_sreg << 1 | key;
    end
end

always @ (posedge clk) begin
    if(!rst_n) begin
        fsm <= S0_IDLE;
        cnt_press   <= 0;
        cnt_release <= 0;
        en <= 0;
    end
    else begin
        case (fsm)
            S0_IDLE: begin
                if(key_is_shake) begin
                    cnt_press <= 'd0;
                    cnt_release <= 'd0;
                    en <= 1;
                end                
                else if(key_is_press && en) begin
                    if(cnt_press < FILTER_TIME)
                        cnt_press <= cnt_press + 1;
                    else begin
                        cnt_press <= 0; //max = FILTER_TIME
                        fsm <= S1_KEY_PRESS;
                    end
                end
                else if(key_is_release && en) begin
                    if(cnt_release < FILTER_TIME)
                        cnt_release <= cnt_release + 1;
                    else begin
                        cnt_release <= 0; //max = FILTER_TIME
                        fsm <= S2_KEY_RELEASE;
                    end
                end
                else begin
                    fsm <= fsm;
                    cnt_press   <= 0;
                    cnt_release <= 0;
                    en <= 0;
                end
            end
            
            S1_KEY_PRESS: begin
                fsm <= S0_IDLE;
                en <= 0; 
            end
            
            S2_KEY_RELEASE: begin
                fsm <= S0_IDLE;
                en <= 0; 
            end
            
            default: begin
                fsm <= fsm;
            end
        endcase
    end
end

endmodule   //get_key end