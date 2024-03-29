%% declaring variables :

global gK gNa gL vK vNa vL v0 C n0 m0 h0;


%% assigning values and equations :

C = 1 ;                 %% unit: uF/cm^2

v0 = -60.045;           %% unit: mV
vNa = 55.17;            %% unit: mV
vK = -72.14 ;           %% unit: mV
vL = -49.42 ;           %% unit: mV


gNa = 120 ;             %% unit: mS/cm^2
gK = 36 ;               %% unit: mS/cm^2
gL = 0.3 ;              %% unit: mS/cm^2

%% Defining opening rate(alpha) and closing rate(beta) of K channel(n), Na channel(m,h) :

an = @(V) (-0.01*(V+50))./(exp(-(V+50)/10)-1) ;
bn = @(V) 0.125*exp(-(V+60)/80) ;

am = @(V) (-0.1*(V+35))./(exp(-(V+35)/10)-1) ;
bm = @(V) 4*exp(-(V+60)/18) ;

ah = @(V) 0.07*exp(-(V+60)/20) ;
bh = @(V) 1./(exp(-(V+30)/10)+1) ;

%% Calculating intial values of n0, m0, and h0 :

n0 = an(v0) ./(an(v0) + bn(v0));

m0 = am(v0) ./ (am(v0) + bm(v0));

h0 = ah(v0) ./ (ah(v0) + bh(v0));


%% Plots of gating Probabilities and membrane potential with various current injection value :

% defining hh model equation :
I = 5;

func = @(t,p) [ (1/C)*(I-(gK*p(2).^4.*(p(1) - vK)) - (gNa*p(3).^3.*p(4).*(p(1)-vNa))-(gL.*(p(1)-vL)));
    ( (an(p(1)).*(1-p(2))) - (bn(p(1)).*p(2)) );
    ( (am(p(1)).*(1-p(3))) - (bm(p(1)).*p(3)) ); 
    ( (ah(p(1)).*(1-p(4))) - (bh(p(1)).*p(4)) ) ] ;

tspan = [0 200] ;

[T, Parameters] = ode15s(func, tspan, [v0 n0 m0 h0]);

I = 0;
[t,p] = ode15s(func,T(end):600,Parameters(end,:));
T = [T;t(2:end)];
Parameters = [Parameters;p(2:end,:)];

I = 5;
[t,p] = ode15s(func,T(end):1000,[v0 n0 m0 h0]);
T = [T;t(2:end)];
Parameters = [Parameters;p(2:end,:)];



figure
plot(T,Parameters(:,1));
xlabel('time');
ylabel('membrane potential (mV)') ;
title(['Membrane potential vs time for I = ' num2str(I) '\muA/cm^2']);

figure
plot(T,Parameters(:,2), T,Parameters(:,3), T, Parameters(:,4));
legend('n(t)', 'm(t)', 'h(t)') ;
xlabel('time') ;
title(['n, m & h vs time for I = ' num2str(I) '\muA/cm^2']);
