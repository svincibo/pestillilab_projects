function bvals_bvecs_split

%% Matlab script for splitting shells and generating data, bvec and bval files for each shell in multi-shell data. Script developed by Franco Pestilli (2014); adapted and used by Brad Caron (IU Graduate Student, 2016) for the microstructure in concussion-prone athletics study.


% seperate bvals/bvecs
% build paths
subj = '1_5'; % subject; add all subjects for batch
b_vals = {'1000','2000'}; % separate shells
stem = 'data'; % stem used for writing output files
projdir1 = '/N/dc2/projects/lifebid/Concussion/concussion_test'; % path to data directory

% Split data into two separate files (BVALS = 1000 and 2000).

bvals = dlmread('data.bvals');
bvals = round(bvals./100)*100;
bvals(bvals==100) = 0;
dlmwrite('data.bvals',bvals)
dwi   = niftiRead('data.nii.gz');
dwi1000 = dwi;
dwi1000.fname = 'data_b1000.nii.gz';
dwi2000 = dwi;
dwi2000.fname = 'data_b2000.nii.gz';
index1000 = (bvals == 1000);
index2000 = (bvals == 2000);
index0    = (bvals == 0);

% Find all indices to each bvalue and B0

all_1000  = or(index1000,index0);
all_2000  = or(index2000,index0);
dwi1000.data = dwi.data(:,:,:,all_1000);
dwi1000.dim(4) = size(dwi1000.data,4);
niftiWrite(dwi1000);
bvals1000 = bvals(all_1000);
dlmwrite('data_b1000.bvals',bvals1000);
bvecs1000 = dlmread('data.bvecs');
bvecs1000 = bvecs1000(:,all_1000);
dlmwrite('data_b1000.bvecs',bvecs1000);
dwi2000.data = dwi.data(:,:,:,all_2000);
dwi2000.dim(4) = size(dwi2000.data,4);
niftiWrite(dwi2000);
bvals2000 = bvals(all_2000);
dlmwrite('data_b2000.bvals',bvals2000);
bvecs2000 = dlmread('data.bvecs');
bvecs2000 = bvecs2000(:,all_2000);
dlmwrite('data_b2000.bvecs',bvecs2000);

for ibv = 1:length(b_vals)
bvecs = fullfile(projdir1, subj, 'diffusion_data', sprintf('data_b%s.bvecs',b_vals{ibv}));
bvals = fullfile(projdir1, subj, 'diffusion_data', sprintf('data_b%s.bvals',b_vals{ibv}));
out   = fullfile(projdir1, subj, 'diffusion_data', 'fibers', sprintf('data_b%s.b', b_vals{ibv}));
mrtrix_bfileFromBvecs(bvecs, bvals, out);
end
exit;
