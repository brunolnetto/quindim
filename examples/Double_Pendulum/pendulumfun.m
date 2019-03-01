function fsubs = pendulumfun(x, th1, th2, xp, th1p, th2p, PWM)
%PENDULUNFUN
%    FSUBS = PENDULUNFUN(PWM,TH1,TH2,TH1P,TH2P,XP)

%    This function was generated by the Symbolic Math Toolbox version 8.1.
%    16-Jan-2019 15:27:33

t3 = th1+th2;
t2 = cos(t3);
t4 = sin(t3);
t5 = cos(th1);
t6 = sin(th1);
t7 = t2.^2;
t8 = t5.^2;
t9 = t6.^2;
t10 = t4.^2;
t11 = th1p.^2;
t12 = th2p.^2;
t13 = t7.*2.335540127443604e-6;
t14 = t10.*2.615174780139212e-6;
t15 = t8.*2.533092524802207e-8;
t16 = t9.*4.177586593799999e-7;
t17 = t7.*t8.*-5.168936343260482e-7;
t18 = t7.*t9.*1.1192660467425e-6;
t19 = t8.*t10.*7.599277574406623e-8;
t20 = t2.*t4.*t5.*t6.*-1.712152456812614e-6;
t21 = t13+t14+t15+t16+t17+t18+t19+t20+8.717249267130706e-7;
t22 = 1.0./t21;
fsubs = [xp;
         th1p;
         th2p;
         t22.*(PWM.*1.536181090530022e-7-xp.*1.485494241562795e-7+PWM.*t7.*4.608543271590066e-7+PWM.*t8.*7.361874523475246e-8+PWM.*t9.*7.361874523475246e-8+PWM.*t10.*4.608543271590066e-7+t2.*t4.*3.359272111358228e-9+t5.*t6.*4.714263880693056e-9+t4.*t11.*1.228305278812957e-11+t4.*t12.*1.228305278812957e-11+t6.*t11.*6.095963254232244e-11+t2.*th2p.*4.491095558544928e-10+t5.*th1p.*1.269945190447455e-10-t5.*th2p.*1.269945190447455e-10-t7.*xp.*4.456482724688386e-7-t8.*xp.*7.118966819176975e-8-t9.*xp.*7.118966819176975e-8-t10.*xp.*4.456482724688386e-7+PWM.*t7.*t9.*2.208562357042574e-7+PWM.*t8.*t10.*2.208562357042574e-7-t2.*t4.*t8.*3.161719079547023e-9-t2.*t4.*t9.*3.161719079547023e-9+t5.*t6.*t7.*9.371201179107141e-9+t5.*t6.*t10.*9.371201179107141e-9+t4.*t7.*t11.*3.684915836438873e-11+t4.*t7.*t12.*3.684915836438873e-11-t4.*t8.*t11.*1.156070751875187e-11-t4.*t8.*t12.*1.156070751875187e-11+t4.*t9.*t11.*5.886434480210489e-12+t6.*t7.*t11.*1.211779812958979e-10+t4.*t9.*t12.*5.886434480210489e-12+t4.*t10.*t11.*3.684915836438873e-11+t6.*t8.*t11.*2.921381916105325e-11+t4.*t10.*t12.*3.684915836438873e-11+t6.*t9.*t11.*2.921381916105325e-11+t6.*t10.*t11.*1.828788976269674e-10-t2.*t8.*th2p.*4.226981930850248e-10+t2.*t9.*th2p.*2.1522776304672e-10+t5.*t7.*th1p.*2.524447542035565e-10-t5.*t7.*th2p.*2.524447542035565e-10+t5.*t10.*th1p.*3.809835571342365e-10-t5.*t10.*th2p.*3.809835571342365e-10+t4.*th1p.*th2p.*2.456610557625915e-11-t7.*t9.*xp.*2.135690045753093e-7-t8.*t10.*xp.*2.135690045753093e-7+t2.*t4.*t5.*t11.*6.17009163310695e-11+t2.*t5.*t6.*t11.*1.744714199896236e-11+t2.*t5.*t6.*t12.*1.744714199896236e-11-t4.*t7.*t8.*t11.*3.468212255625561e-11-t4.*t7.*t8.*t12.*3.468212255625561e-11+t6.*t7.*t8.*t11.*5.807239125698614e-11-t4.*t8.*t10.*t11.*3.468212255625561e-11+t6.*t7.*t9.*t11.*5.807239125698614e-11-t4.*t8.*t10.*t12.*3.468212255625561e-11-t2.*t4.*t6.*th1p.*1.2853880293068e-10+t2.*t4.*t6.*th2p.*1.2853880293068e-10-t4.*t5.*t6.*th2p.*6.379259561317448e-10+t4.*t7.*th1p.*th2p.*7.369831672877746e-11-t4.*t8.*th1p.*th2p.*2.312141503750373e-11+t4.*t9.*th1p.*th2p.*1.177286896042098e-11+t4.*t10.*th1p.*th2p.*7.369831672877746e-11-PWM.*t2.*t4.*t5.*t6.*4.417124714085149e-7-t2.*t4.*t5.*t8.*t11.*5.807239125698614e-11-t2.*t4.*t5.*t9.*t11.*5.807239125698614e-11+t2.*t5.*t6.*t7.*t11.*3.468212255625561e-11+t2.*t5.*t6.*t7.*t12.*3.468212255625561e-11+t2.*t5.*t6.*t10.*t11.*3.468212255625561e-11+t2.*t5.*t6.*t10.*t12.*3.468212255625561e-11+t2.*t5.*t6.*th1p.*th2p.*3.489428399792471e-11-t4.*t7.*t8.*th1p.*th2p.*6.936424511251122e-11-t4.*t8.*t10.*th1p.*th2p.*6.936424511251122e-11+t2.*t4.*t5.*t6.*xp.*4.271380091506186e-7+t2.*t5.*t6.*t7.*th1p.*th2p.*6.936424511251122e-11+t2.*t5.*t6.*t10.*th1p.*th2p.*6.936424511251122e-11).*8.157777951810374e2;
         t22.*(t6.*8.263787343279677e-8+th1p.*2.226128459727999e-9-th2p.*2.226128459727999e-9+PWM.*t5.*1.212237981917281e-6+t6.*t7.*2.214047843929902e-7+t6.*t10.*1.642708504553383e-7+t7.*th1p.*5.964280918458e-9-t7.*th2p.*5.964280918458e-9+t10.*th1p.*6.678385379184e-9-t10.*th2p.*6.678385379184e-9-t5.*xp.*1.172239752619603e-6+PWM.*t5.*t7.*2.40973485850597e-6+PWM.*t5.*t10.*3.636713945751845e-6-t2.*t4.*t5.*5.713393393765191e-8+t2.*t6.*t11.*3.058366584397312e-10+t2.*t6.*t12.*3.058366584397312e-10-t4.*t5.*t11.*2.089080917788292e-10-t4.*t5.*t12.*2.089080917788292e-10+t5.*t6.*t11.*4.810473347645976e-10-t2.*t5.*th2p.*7.638379638315195e-9-t4.*t6.*th2p.*1.1182412727936e-8-t5.*t7.*xp.*2.330224787995982e-6-t5.*t10.*xp.*3.516719257858811e-6-PWM.*t2.*t4.*t6.*1.226979087245875e-6-t2.*t4.*t8.*t11.*1.049398786609933e-9+t2.*t4.*t9.*t11.*1.049398786609933e-9+t2.*t6.*t7.*t11.*8.194027339823523e-10+t2.*t6.*t7.*t12.*8.194027339823523e-10-t4.*t5.*t7.*t11.*6.267242753364878e-10-t4.*t5.*t7.*t12.*6.267242753364878e-10+t2.*t6.*t10.*t11.*8.194027339823523e-10+t5.*t6.*t7.*t11.*2.005643804886172e-9+t2.*t6.*t10.*t12.*8.194027339823523e-10-t4.*t5.*t10.*t11.*6.267242753364878e-10-t4.*t5.*t10.*t12.*6.267242753364878e-10-t5.*t6.*t10.*t11.*9.315376833369424e-11+t2.*t6.*th1p.*th2p.*6.116733168794624e-10-t4.*t5.*th1p.*th2p.*4.178161835576585e-10+t2.*t4.*t6.*xp.*1.186494469862829e-6+t2.*t6.*t7.*th1p.*th2p.*1.638805467964705e-9-t4.*t5.*t7.*th1p.*th2p.*1.253448550672976e-9+t2.*t6.*t10.*th1p.*th2p.*1.638805467964705e-9-t4.*t5.*t10.*th1p.*th2p.*1.253448550672976e-9).*-8.157777951810374e2;
         t22.*(t4.*2.922445701856356e-7-t6.*8.263787343279677e-8-th1p.*2.226128459727999e-9+th2p.*4.129704167130785e-8+PWM.*t2.*4.287016996827968e-6-PWM.*t5.*1.212237981917281e-6+t4.*t8.*8.492157485304219e-9-t4.*t9.*2.750581682042874e-7-t6.*t7.*2.214047843929902e-7-t6.*t10.*1.642708504553383e-7-t7.*th1p.*5.964280918458e-9+t7.*th2p.*5.964280918458e-9+t8.*th2p.*1.13533793930416e-9+t9.*th2p.*1.8724039916544e-8-t10.*th1p.*6.678385379184e-9+t10.*th2p.*6.678385379184e-9-t2.*xp.*4.145565325291522e-6+t5.*xp.*1.172239752619603e-6-PWM.*t2.*t8.*4.034904879358833e-6+PWM.*t2.*t9.*2.054476611202395e-6-PWM.*t5.*t7.*2.40973485850597e-6-PWM.*t5.*t10.*3.636713945751845e-6+t2.*t4.*t5.*5.713393393765191e-8-t2.*t5.*t6.*2.835503256895916e-7+t2.*t4.*t11.*3.427828685059417e-10+t2.*t4.*t12.*3.427828685059417e-10-t2.*t6.*t11.*3.97239502231991e-9-t2.*t6.*t12.*3.058366584397312e-10+t4.*t5.*t11.*5.576665503351728e-9+t4.*t5.*t12.*2.089080917788292e-10-t5.*t6.*t11.*4.810473347645976e-10-t2.*t5.*th1p.*7.638379638315195e-9+t2.*t5.*th2p.*1.527675927663039e-8-t4.*t6.*th1p.*1.1182412727936e-8+t4.*t6.*th2p.*2.2364825455872e-8+t2.*t8.*xp.*3.901771738039783e-6-t2.*t9.*xp.*1.98668841465404e-6+t5.*t7.*xp.*2.330224787995982e-6+t5.*t10.*xp.*3.516719257858811e-6+PWM.*t2.*t4.*t6.*1.226979087245875e-6-PWM.*t4.*t5.*t6.*6.089381490561228e-6+t2.*t4.*t8.*t11.*1.776173177347721e-9+t2.*t4.*t8.*t12.*7.267743907377879e-10-t2.*t4.*t9.*t11.*2.421421969092011e-9-t2.*t6.*t7.*t11.*8.194027339823523e-10-t2.*t4.*t9.*t12.*1.372023182482078e-9-t2.*t6.*t7.*t12.*8.194027339823523e-10-t2.*t6.*t8.*t11.*1.757132851998028e-9+t4.*t5.*t7.*t11.*6.267242753364878e-10-t2.*t6.*t9.*t11.*1.757132851998028e-9+t4.*t5.*t7.*t12.*6.267242753364878e-10+t4.*t5.*t8.*t11.*1.55978402791302e-10-t2.*t6.*t10.*t11.*8.194027339823523e-10+t4.*t5.*t9.*t11.*1.55978402791302e-10-t5.*t6.*t7.*t11.*3.055042591496105e-9-t2.*t6.*t10.*t12.*8.194027339823523e-10+t4.*t5.*t10.*t11.*6.267242753364878e-10-t5.*t6.*t7.*t12.*1.049398786609933e-9+t4.*t5.*t10.*t12.*6.267242753364878e-10+t5.*t6.*t10.*t11.*1.142552554943627e-9+t5.*t6.*t10.*t12.*1.049398786609933e-9+t2.*t4.*th1p.*th2p.*6.855657370118833e-10-t2.*t6.*th1p.*th2p.*6.116733168794624e-10+t4.*t5.*th1p.*th2p.*4.178161835576585e-10-t2.*t4.*t6.*xp.*1.186494469862829e-6+t4.*t5.*t6.*xp.*5.888460152693823e-6+t2.*t4.*t8.*th1p.*th2p.*1.453548781475576e-9-t2.*t4.*t9.*th1p.*th2p.*2.744046364964157e-9-t2.*t6.*t7.*th1p.*th2p.*1.638805467964705e-9+t4.*t5.*t7.*th1p.*th2p.*1.253448550672976e-9-t2.*t6.*t10.*th1p.*th2p.*1.638805467964705e-9-t5.*t6.*t7.*th1p.*th2p.*2.098797573219866e-9+t4.*t5.*t10.*th1p.*th2p.*1.253448550672976e-9+t5.*t6.*t10.*th1p.*th2p.*2.098797573219866e-9).*-8.157777951810374e2];
