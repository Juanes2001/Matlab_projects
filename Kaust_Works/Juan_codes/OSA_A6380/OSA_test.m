%%% EJEMPLO DE CONECCION ETHERNET CON EL OSA AQ6380
time = 5;
osa = A6380_class();

pause(time)

osa.init(); % We initiate the communication

pause(time)

osa.set_center_lam(1300);

pause(time)

osa.set_span(20);

pause(time)

osa.set_sweep_repeat();

pause(time)

osa.set_sweep_single();

pause(time)

osa.do_sweep();

pause(time)

osa.deleteObj();



