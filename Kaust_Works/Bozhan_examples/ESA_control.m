%%

global VISAMng
VISAMng.setBufferLength(1E8);

esa = FSU;
esa.setBufferLength(1E6);
 
%%
index = 1;
esa.set('SWEEP:COUNT 5');
pause(12)
data.esa(index).x = esa.x;
data.esa(index).y = esa.y;
data.current(index) = 72;
plot(data.esa(index).x,data.esa(index).y)
esa.set('SWEEP:COUNT 1');

%%

data.noise.x = esa.x;
data.noise.y = esa.y;
plot(data.noise.x,data.noise.y)
 
 %%
save('20180504_QDL_esa.mat','data','-mat')
disp('Save finish')
  