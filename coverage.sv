module top;

parameter PERIOD = 1;
parameter DWAYS = 8;
parameter IWAYS = 4;
parameter CACHETYPE = 3;
parameter INDEXSEL = 19;
parameter WAYNUM = 23;
parameter MESI = 27;
bit [0:1]DMESI[int][DWAYS];
bit [0:1]IMESI[int][IWAYS];

bit [0:27] Mem[$];
bit clk;
bit flag;
int file; 


always
    begin
    #PERIOD clk =~clk;
    end

//define I					0
//define M					1
//define E					2
//define S					3


covergroup dcache_cover with function sample(bit [0:1] h);
 
    coverpoint h
        { bins MESII[]    = {0,1,2,3};
          bins STATE      = (1[=1]=>2[=1]=>3[=1]=>0[=1]);
         }
endgroup

covergroup icache_cover with function sample(bit [0:1] g);
 
    coverpoint g
        { bins MESII[]      = {2,3}; 
          bins STATE        = (2[=1]=>3[=1]);
 } 
endgroup

 /*
 covergroup dcache @(posedge clk);
    coverpoint DMESI[][]
    { bins MESII = {0,1,2,3} ;}
 endgroup

 covergroup icache @(posedge clk);
    coverpoint IMESI[][]
    { bins MESII = {0,1,2,3} ;}
 endgroup

dcache dcc = new();
icache icc = new();
*/
dcache_cover dcc[int][int]; 
icache_cover icc[int][int];




initial
begin
$readmemh("coverage.txt",Mem);
file = $fopen("coverage_debug.txt","ab");
//debug();
create_cover();
foreach(dcc[i,j])
$fdisplay(file,"DCC SIZE %1d\t index :- %4x",dcc[i].size,i);
foreach(icc[i,j])
$fdisplay(file,"ICC SIZE %1d \t index :- %4x",icc[i].size,i);
run_cover();
$fclose(file);
$finish;
end



function void debug();
foreach(Mem[i])
begin
$fdisplay(file,"Type :-%0d Index :-%4x way_num :-%1d mesi :-%1d",Mem[i][0:CACHETYPE],
                Mem[i][CACHETYPE+1:INDEXSEL],Mem[i][INDEXSEL+1:WAYNUM],Mem[i][WAYNUM+3:MESI]);
end
endfunction

task run_cover();
foreach(Mem[i])
begin
@(negedge clk);
if(Mem[i][0:CACHETYPE])
    begin
        DMESI[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]] = Mem[i][WAYNUM+3:MESI];
        //$display(DMESI[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]]," ",Mem[i][WAYNUM+3:MESI]);
    end
else
    begin
        IMESI[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]] = Mem[i][WAYNUM+3:MESI];
        //$display(IMESI[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]]," ",Mem[i][WAYNUM+3:MESI]);
    end

@(posedge clk);
if(Mem[i][0:CACHETYPE])
    dcc[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]].sample( 
                DMESI[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]]  );
else
    icc[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]].sample(
                IMESI[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]] );


end
endtask


function void create_cover();
foreach(Mem[i])
begin
if(Mem[i][0:CACHETYPE] === 1'b1)
    begin
        if(!dcc.exists(Mem[i][CACHETYPE+1:INDEXSEL]))
            begin
            if(!dcc[Mem[i][CACHETYPE+1:INDEXSEL]].exists(Mem[i][INDEXSEL+1:WAYNUM]))
            dcc[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]] = new();
            end
            else
            begin
            if(!dcc[Mem[i][CACHETYPE+1:INDEXSEL]].exists(Mem[i][INDEXSEL+1:WAYNUM]))
            dcc[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]] = new();
            end
    end
else
    begin
            if(!icc.exists(Mem[i][CACHETYPE+1:INDEXSEL]))
            begin
            if(!icc[Mem[i][CACHETYPE+1:INDEXSEL]].exists(Mem[i][INDEXSEL+1:WAYNUM]))
            icc[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]] = new();
            end
            else
            begin
            if(!icc[Mem[i][CACHETYPE+1:INDEXSEL]].exists(Mem[i][INDEXSEL+1:WAYNUM]))
            icc[Mem[i][CACHETYPE+1:INDEXSEL]][Mem[i][INDEXSEL+1:WAYNUM]] = new();
            end



    end
end
endfunction


endmodule


