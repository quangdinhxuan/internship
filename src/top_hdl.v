module top_hdl(
    //Inputs
    input gclk,      // 27MHz
    input gresetn,    
    input key,
    
    //Outputs
    output reg led
);

//localparam
localparam KEY_PRESS   = 1'b0; 
localparam KEY_RELEASE = !KEY_PRESS;
localparam LED_ON      = 1'b1;
localparam LED_OFF     = !LED_ON;

wire flag_press;
wire flag_release;

drv_key #(
    .FILTER_TIME(27_000_0*5),  //50ms
    .KEY_PRESS(KEY_PRESS)
)drv_key_ut0(
    //Inputs
    .clk  (gclk),
    .rst_n(gresetn),
    .key  (key),
    
    //Outputs
    .flag_press  (flag_press),
    .flag_release(flag_release)
);

always @ (posedge gclk) begin
    if(!gresetn) begin
        led <= LED_ON;
    end
    else if(flag_press) begin
        led <= !led;
    end
end

wire clk_osc;       //250/2=125MHz, gao use clock
Gowin_OSC Gowin_OSC_ut0(
    .oscout(clk_osc), 
    .oscen(1'b1) 
);

endmodule