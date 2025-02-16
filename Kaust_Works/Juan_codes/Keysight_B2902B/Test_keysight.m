Keysight = B2902B_class("NI", 23, 0);
Keysight.init();



disp(Keysight.iDN());

Keysight.en_CH1_meas();

disp(Keysight.get_CH1_measV());

disp(Keysight.set_CH1_limitV(0.1));

Keysight.set_CH1_srcI();
Keysight.set_CH1_srcV();

disp(Keysight.set_CH1_srcLevelV(90E-3))


disp(Keysight.enable_CH1());

Keysight.disable_CH1();

Keysight.deleteObj();

