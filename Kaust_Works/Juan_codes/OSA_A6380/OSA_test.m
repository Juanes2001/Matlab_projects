%%% EJEMPLO DE CONECCION ETHERNET CON EL OSA AQ6380

osa = A6380_class();

osa.init(); % We initiate the communication

pause(2);

osa.set_center_lam(1310E-9);

osa.set_span(40E-9);

osa.set_sweep_single();

osa.do_sweep();

osa.deleteObj();