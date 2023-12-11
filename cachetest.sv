package cacheconstraint_test;

class CacheTest;

    parameter HIT_WEIGHT = 10;
    parameter MISS_WEIGHT = 2;
    parameter INDEX = 14;
    parameter BYTE = 6;
    parameter TAG = 12;
    rand bit [TAG+BYTE+INDEX-1:0] mem[];
    rand bit [INDEX-1:0]ind;
    rand bit [TAG-1:0]tag;
    rand int mode[];
    rand int sizemem;
    randc int Sel;
    int NUM_CASES;
    bit [TAG+BYTE+INDEX-1:0] prev_mem[$];
    int prev_mode[$];

    constraint size     { mem.size inside{[10:20]};
                          mode.size == mem.size;
                          solve mem before mode; }

    constraint memaddr {unique{mem};}

    constraint modesel { foreach(mode[i]) { mode[i] dist{[0:2]:=HIT_WEIGHT,
                                     
                                            [3:4]:=HIT_WEIGHT/2,[8:9]:/HIT_WEIGHT+MISS_WEIGHT}; } }
                          
    constraint testsel { Sel inside{0,2,4};}

    function void post_randomize();
    begin

        if(NUM_CASES == 0)
            begin
                Sel = {$random%4};
            end
        if(Sel == 0) //sametag_sameindex
            begin
                foreach(mem[i])
                begin
                    mem[i][INDEX+BYTE-1:BYTE] = ind;
                    mem[i][TAG+INDEX+BYTE-1:INDEX+BYTE] = tag;
                end
            end
        else if(Sel == 1) //sametag_diffindex
            begin
                foreach(mem[i])
                begin
                    mem[i][TAG+INDEX+BYTE-1:INDEX+BYTE] = tag;
                end
            end
        else if(Sel == 2) //difftag_sameindex
            begin
                foreach(mem[i])
                begin
                    mem[i][INDEX+BYTE-1:BYTE] = ind;
                end
            end
        //else if(Sel == 3) //difftag_diffindex
        else if(Sel == 4 && NUM_CASES >0) //previous_addresses_modes
            begin
                foreach(mem[i])
                begin
                    mem[i]  = prev_mem .pop_front();
                    mode[i] = prev_mode.pop_front();
                end 
            end

        foreach(mem[i])
        begin
            prev_mem .push_front(mem[i]);
            prev_mode.push_front(mode[i]);
        end
    ++NUM_CASES;

    end
    endfunction

endclass


endpackage

module top();


import cacheconstraint_test::*;

CacheTest C1;
int TestSel;
int f;
process job;

initial
begin
    automatic int seeed = get_localtime();
    job = process::self();
    job.srandom(seeed);
    C1 = new;
    f = $fopen("testFile.txt","ab");
    repeat(300)
    begin
        C1.randomize();
        filewrite(C1);
    end
    $fclose(f);
end

function void filewrite(CacheTest g);
foreach(g.mode[i])
    begin
        $fdisplay(f,"%0d ",g.mode[i],"%0x",g.mem[i]);
    end
endfunction

    function int unsigned get_localtime();    
    int fd;
    int unsigned localtime;
    void'($system("echo $(($(date +%s%N)/1000000))> localtime")); // temp file
    fd = $fopen("localtime", "r");
    void'($fscanf(fd,"%d",localtime));
    $fclose(fd);
    void'($system("rm localtime")); // delete file
    return localtime;
    endfunction

endmodule




