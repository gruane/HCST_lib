function imSizeBytes = hcst_andor_getImageSizeBytes(bench)
%hcst_andor_getImageSizeBytes Queries the current image size in bytes the Andor Neo camera
%
%   - Returns the current image size in bytes
%   - Uses the atcore.h and libatcore.so 'c' libraries
%   
%
%   Inputs:   
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%   Outputs
%       'imSizeBytes' - Image size in bytes

    andor_handle = bench.andor.andor_handle;

    imSizeBytesFeaturePtr = libpointer('voidPtr',int32(['ImageSizeBytes',0]));
    imSizeBytesPtr = libpointer('int64Ptr',int64(0));
    err = calllib('lib', 'AT_GetInt', andor_handle, imSizeBytesFeaturePtr, imSizeBytesPtr);
    if(err~=0)
        error(['HCST_lib Andor lib ERROR:',num2str(err),' AT_GetInt']);
    end
    imSizeBytes = get(imSizeBytesPtr);
    imSizeBytes = imSizeBytes.Value;
    
end

