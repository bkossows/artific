rois = [
    '/Users/bkossows/Lokalne/swps/norm/ROIAga/MotorCortex/rwEksperymentalny-Kontorlny.nii  '
    '/Users/bkossows/Lokalne/swps/norm/ROIAga/MotorCortex/rwKontrolny.nii                  '
    '/Users/bkossows/Lokalne/swps/norm/ROIAga/STG/rwEksperymentalny-Kontrolny.nii          '
    '/Users/bkossows/Lokalne/swps/norm/ROIAga/STG/rwKontrolny.nii                          '
    '/Users/bkossows/Lokalne/swps/norm/ROIGabrysia/FFA/rwFFAEksperymentalny-Kontrolny.nii  '
    '/Users/bkossows/Lokalne/swps/norm/ROIGabrysia/FFA/rwFFAWarunekKontrolny.nii           '
    '/Users/bkossows/Lokalne/swps/norm/ROIGabrysia/VWFA/rwVWFAEksperymentalny-Kontrolny.nii'
    '/Users/bkossows/Lokalne/swps/norm/ROIGabrysia/VWFA/rwVWFAWarunekKontrolny.nii         '
    '/Users/bkossows/Lokalne/swps/norm/ROIJanek/ACC/rwEksperymentalny-Kontrolny.nii        '
    '/Users/bkossows/Lokalne/swps/norm/ROIJanek/ACC/rwKontrolny.nii                        '
    '/Users/bkossows/Lokalne/swps/norm/ROIJanek/TPJ/rwEksperymentalny-Kontrolny.nii        '
    '/Users/bkossows/Lokalne/swps/norm/ROIJanek/TPJ/rwKontrolny.nii                        '
];

Iv=spm_vol('/Users/bkossows/Lokalne/swps/raw/fmri_run-01.nii');
I=spm_read_vols(Iv);
c=spm_read_vols(spm_vol(strtrim(rois(2,:))))>0;
m=spm_read_vols(spm_vol(strtrim(rois(1,:))))>0;

%common activations
design=repmat([0 0 0 0 0 1 1 1 1 1],1,size(I,4)/10);
c=repmat(c,1,1,1,size(I,4));
c(:,:,:,~design)=0;
c=(c*.04)+1;
I=I.*c;

%specific activations (each 2nd block)
design=repmat([0 0 0 0 0 0 0 0 0 0  0 0 0 0 0 1 1 1 1 1],1,size(I,4)/20);
m=repmat(m,1,1,1,size(I,4));
m(:,:,:,~design)=0;
m=(m*.08)+1;
I=I.*m;

%shift for HRF delay circshift(I, vol*TR, dim)
% for TR=2s & shift=3 -> delay=6s 
I=circshift(I,3,4);

for i=1:size(I,4)
   Iv(i).fname=sprintf('test.nii',i);
   %add motion
   %I(:,:,:,i)=circshift(I(:,:,:,i),randi(4)-2,randi(3)); 
   spm_write_vol(Iv(i),I(:,:,:,i));
end

