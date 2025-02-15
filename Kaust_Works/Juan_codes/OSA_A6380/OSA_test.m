%%% EJEMPLO DE CONECCION ETHERNET CON EL OSA AQ6380
time = 0.5;
osa = A6380_class('10.72.171.65');

pause(time)

osa.init(); % We initiate the communication

osa.clear_status();

pause(time)

osa.set_center_lam(1300);

pause(time)

osa.set_span(20);

pause(time)

osa.set_sweep_repeat();
osa.do_sweep();

pause(time)

osa.abort();

osa.set_sweep_single();

pause(time)

osa.do_sweep();

while ~osa.issweepDone() 
    %%%
end

pause(time)

osa.deleteObj();



