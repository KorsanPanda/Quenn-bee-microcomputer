 -- Prosedürler (Procedure'ler) Tanýmlanýyor:
    procedure perform_cma is
    begin
        cma_en <= '1';
        AC <- NOT AC;
    end perform_cma;

    procedure perform_stp is
    begin
        stp_en <= '1';
        -- Diðer ilgili iþlemleri buraya ekleyebilirsiniz.
    end perform_stp;

    procedure perform_hlt is
    begin
        hlt_en <= '1';
        S <- 0;
    end perform_hlt;

    procedure perform_inp is
    begin
        inp_en <= '1';
        AC(0-7) <-INPR
    end perform_inp;

    procedure perform_out is
    begin
        out_en <= '1';
        -- Diðer ilgili iþlemleri buraya ekleyebilirsiniz.
    end perform_out;

    procedure perform_ion is
    begin
        ion_en <= '1';
        -- Diðer ilgili iþlemleri buraya ekleyebilirsiniz.
    end perform_ion;

    procedure perform_iof is
    begin
        iof_en <= '1';
        -- Diðer ilgili iþlemleri buraya ekleyebilirsiniz.
    end perform_iof;
