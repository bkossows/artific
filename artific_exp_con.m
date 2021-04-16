for sel=1:2:11
    
design_code='5';
tr=2;
dataset='bk';

rois = [
    '/Users/bkossows/Lokalne/swps/norm2/ROIAga/MotorCortex/rwEksperymentalny.nii         '
    '/Users/bkossows/Lokalne/swps/norm2/ROIAga/MotorCortex/rwKontrolny.nii               '
    '/Users/bkossows/Lokalne/swps/norm2/ROIAga/STG/rwEksperymentalny.nii                 '
    '/Users/bkossows/Lokalne/swps/norm2/ROIAga/STG/rwKontrolny.nii                       '
    '/Users/bkossows/Lokalne/swps/norm2/ROIGabrysia/FFA/rwFFAWarunekEksperymentalny.nii  '
    '/Users/bkossows/Lokalne/swps/norm2/ROIGabrysia/FFA/rwFFAWarunekKontrolny.nii        '
    '/Users/bkossows/Lokalne/swps/norm2/ROIGabrysia/VWFA/rwVWFAWarunekEksperymentalny.nii'
    '/Users/bkossows/Lokalne/swps/norm2/ROIGabrysia/VWFA/rwVWFAWarunekKontrolny.nii      '
    '/Users/bkossows/Lokalne/swps/norm2/ROIJanek/ACC/rwEksperymentalny.nii               '
    '/Users/bkossows/Lokalne/swps/norm2/ROIJanek/ACC/rwKontrolny.nii                     '
    '/Users/bkossows/Lokalne/swps/norm2/ROIJanek/TPJ/rwEksperymentalny.nii               '
    '/Users/bkossows/Lokalne/swps/norm2/ROIJanek/TPJ/rwKontrolny.nii                     '
];

Iv=spm_vol('/Users/bkossows/Lokalne/swps/raw2/cfmri.nii');
I=spm_read_vols(Iv);
e=spm_read_vols(spm_vol(strtrim(rois(sel,:))))>0;
c=spm_read_vols(spm_vol(strtrim(rois(sel+1,:))))>0;

%control
design=repmat([0 0 0 0 0 1 1 1 1 1  0 0 0 0 0 0 0 0 0 0],1,size(I,4)/20);
c=repmat(c,1,1,1,size(I,4));
c(:,:,:,~design)=0;
c=(c*.08)+1;
I=I.*c;

%experimental
design=repmat([0 0 0 0 0 0 0 0 0 0  0 0 0 0 0 1 1 1 1 1],1,size(I,4)/20);
e=repmat(e,1,1,1,size(I,4));
e(:,:,:,~design)=0;
e=(e*.08)+1;
I=I.*e;

%shift for HRF delay circshift(I, vol*TR, dim)
% for TR=2s & shift=3 -> delay=6s 
I=circshift(I,6/tr,4);

for i=1:size(I,4)
   Iv(i).fname=[dataset,'_tr',num2str(tr),'_design',design_code,'_roi',num2str(sel),'.nii'];
   %add motion
   I(:,:,:,i)=circshift(I(:,:,:,i),randi(4)-2,randi(3)); 
   spm_write_vol(Iv(i),I(:,:,:,i));
end

end
