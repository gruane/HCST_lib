function hcst_andor_fitswrite(B,im,flnm,show)
%hcst_andor_fitswrite(B,im,flnm)
%Writes an image to a FITS file.
%
%   Inputs:   
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%
%       'im' is an array containing the image
%
%       'flnm' is a string continaing the destination filename
%
%       'show' is a logical. If 'show' is set, the created FITS file will
%           opened in DS9.
%
%   Outputs:
%       None
    
    disp(['Writing image file...', flnm]);

    lamOverD = B.bench.andor.pixelPerLamOverD;
    pei = B.bench.andor.default_pixelEncodingIndex;
    numCoadds = B.bench.andor.numCoadds;
    tint = B.bench.andor.tint;

    centcol = B.bench.andor.centcol;
    centrow = B.bench.andor.centrow;
    
    [rows,cols,dims] = size(im);

    import matlab.io.*
    try
        fptr = fits.createFile(flnm);
    catch 
        delete(flnm);
        fptr = fits.createFile(flnm);
    end
    fits.createImg(fptr,'double_img',[rows,cols,dims]);
    fits.writeImg(fptr,im);
    
    fits.writeKey(fptr,'DATE',datestr(now,'yyyymmdd'),'Date (yyyymmdd)');
    fits.writeKey(fptr,'TIME',datestr(now,'HHMMSS'),'Time (hhmmss)');
    fits.writeKey(fptr,'TINT',tint,'Integration time (sec)');
    fits.writeKey(fptr,'COADDS',numCoadds,'Number of coadds');
    fits.writeKey(fptr,'HEIGHT',B.bench.andor.AOIHeight,'AOI Height');
    fits.writeKey(fptr,'WIDTH',B.bench.andor.AOIWidth,'AOI Width');
    fits.writeKey(fptr,'CENTCOL',centcol,'Column of sub-window center');
    fits.writeKey(fptr,'CENTROW',centrow,'Row of sub-window center');
    fits.writeKey(fptr,'LAMOVERD',lamOverD,'lambda_0/D in pixels');
    fits.writeKey(fptr,'PIXENCOD',pei,'pixel encoding index');
    fits.closeFile(fptr);
    fitsdisp(flnm,'mode','full');

    if(show)
        system(['ds9 ',flnm,' &']);
    end

end

