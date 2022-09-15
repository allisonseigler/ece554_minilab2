  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  tpumac iDUT(.clk(clk), .rst_n(rst_n), .en(en), .WrEn(WrEn), 
           .Ain(Ain), .Bin(Bin), .Cin(Cin), .Aout(Aout), .Bout(Bout), .Cout(Cout));

  integer error = 0;
  
  initial begin
$display("Starting tests\n");
     // Initial setup
     clk = 0;
     rst_n = 0;
     @(negedge clk);
     rst_n = 1;
    @(posedge clk);
    if (Aout !== 0 || Bout !== 0 || Cout !== 0) begin
      $display("ERROR: values not reset\n");
      error+=1;
    end
	Aout_old = 8'd0;
	Bout_old = 8'd0;
	Cout_old = 16'd0;
	@(negedge clk);
    for (integer i=0; i<56; i = i+1) begin
      Ain = $random;
      Bin = $random;
      Cin = $random;
      en = $random;
      WrEn = $random;
      
      @(negedge clk);
      
      if (en === 0) begin
        if (Aout !== Aout_old) begin
          $display("ERROR cycle %d: en is false, Aout shouldn't change\n", i);
          error+=1;
        end
        if (Bout !== Bout_old) begin
          $display("ERROR cycle %d: en is false, Bout shouldn't change\n", i);
          error+=1;
        end
        if (Cout !== Cout_old) begin
          $display("ERROR cycle %d: en is false, Cout shouldn't change\n", i);
          error+=1;
        end
      end
      else begin
        if (Aout !== Ain) begin
          $display("ERROR cycle %d: Aout should match Ain, Aout = %h, Ain = %h\n", i, Aout, Ain);
          error+=1;
        end
        if (Bout !== Bin) begin
          $display("ERROR cycle %d: Bout should match Bin, Bout = %h, Bin = %h\n", i, Bout, Bin);
          error+=1;
        end
        if (WrEn === 1) begin
          if (Cout !== Cin) begin
            $display("ERROR cycle %d: WrEn true, Cout should be Cin, Cout = %h, Cin = %h\n", i, Cout, Cin);
            error+=1;
          end
        end
        else begin
          Cout_exp = Ain * Bin + Cout_old;
          if (Cout !== Cout_exp) begin
            $display("ERROR cycle %d: Cout calculation wrong, Cout = %h, should be %h\n", i, Cout, Cout_exp);
            error+=1;
          end
        end
      end
      Aout_old = Aout;
      Bout_old = Bout;
      Cout_old = Cout;
      
    end

if (error === 0) begin
	$display("YAHOO! tests passed!\n");
	$stop;
end
else begin
	$display("Test failed with %d errors\n", error);
	$stop;
end
  end

always #5 clk = ~clk;

endmodule
