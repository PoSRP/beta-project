clc
clear

%% Plot of plantTest no controller

load PlantTestData.mat
min = -1;
max = 6;
antalFigs = 3

subplot(antalFigs,1,1)
hold on 
plot(out.Lin_Plant.time, out.Lin_Plant.data(:,2), "color", "r");
plot(out.Lin_Plant.time, out.Lin_Plant.data(:,1), "color", "b");
hold off
title("Linearized Plant")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([min max])

subplot(antalFigs,1,2)
hold on 
plot(out.simscape.time, out.simscape.data(:,2), "color", "r");
plot(out.simscape.time, out.simscape.data(:,1), "color", "b");
hold off
title("Simscape")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([min max])

subplot(antalFigs,1,3)
hold on 
plot(out.Lin_Plant.time, out.motionEqn.data(:,2), "color", "r");
plot(out.Lin_Plant.time, out.motionEqn.data(:,1), "color", "b");
hold off
title("MotionEquation")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
xlabel('$Time$ [s]','interpreter','latex')
grid on
ylim([min max])

x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*150;
set(gcf,'position',[x0,y0,width,height])




%% Plot af plant test med controllers 
load PlantTestDataMControl1.mat
out1 = out;
load PlantTestDataMControl2.mat
out2 = out;
load PlantTestDataMControl3.mat
out3 = out;

min = -2.5;
max = 1.5;
antalFigs = 3

subplot(antalFigs,1,1)
hold on 
plot(out1.u.time, out1.angle.data(:,1), "color", "r");
plot(out1.u.time, out1.position.data(:,1), "color", "b");
hold off
title("Linearized Plant")
legend("\theta [rad]", "P [m]", 'Location','northeast')
%xlabel("time")
ylabel("output y")
grid on
ylim([min max])

subplot(antalFigs,1,2)
hold on 
plot(out2.u.time, out2.angle.data(:,1), "color", "r");
plot(out2.u.time, out2.position.data(:,1), "color", "b");
hold off
title("Simscape")
legend("\theta [rad]", "P [m]", 'Location','northeast')
%xlabel("time")
ylabel("output y")
grid on
ylim([min max])

subplot(antalFigs,1,3)
hold on 
plot(out3.u.time, out3.angle.data(:,1), "color", "r");
plot(out3.u.time, out3.position.data(:,1), "color", "b");
hold off
title("MotionEquation")
legend("\theta [rad]", "P [m]", 'Location','northeast')
%xlabel("time")
ylabel("output y")
xlabel('$Time$ [s]','interpreter','latex')
grid on
ylim([min max])

x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*150;
set(gcf,'position',[x0,y0,width,height])

%%
hold on 
plot(out2.u.time, out2.angle.data(:,1), "color", "r");
plot(out2.u.time, out2.position.data(:,1), "color", "b");
hold off
title("Simscape")
legend("\theta [rad]", "P [m]", 'Location','northeast')
xlabel('$Time$ [s]','interpreter','latex')
ylabel("output y")
grid on
ylim("auto")


%% plottiong af controller tests 
load ControllerTest1.mat
outCAS = out;
load ControllerTest2.mat
outPAR = out;
load ControllerTest3.mat
outLQG = out;
load ControllerTest4.mat
outLQR = out;
load ControllerTest5.mat
outSTATEPID = out;
load ControllerTest6.mat
outDLQG = out;


f1 = figure()

min = -2.5;
max = 1.5;
antalFigs = 3

subplot(antalFigs,1,1)
hold on 
plot(outCAS.u.time, outCAS.angle.data(:,1), "color", "r");
plot(outCAS.u.time, outCAS.position.data(:,1), "color", "b");
hold off
title("Cascade PID controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])

subplot(antalFigs,1,2)
hold on 
plot(outCAS.u.time, outCAS.u.data(:,1), "color", "b");
hold off
title("Applied force")
legend("u [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-15 15])

subplot(antalFigs,1,3)
hold on 
plot(outCAS.u.time, outCAS.rpm.data(:,1), "color", "b");
hold off
title("Force converted to motor RPM")
legend("Motor velocity [RPM]", 'Location','northwest')
%xlabel("time")
ylabel("[RPM]")
xlabel('$Time$ [s]','interpreter','latex')
grid on
ylim([-175 175])

x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*150;
set(gcf,'position',[x0,y0,width,height])


% ny 
f2 = figure()

min = -2.5;
max = 1.5;
antalFigs = 3

subplot(antalFigs,1,1)
hold on 
plot(outPAR.u.time, outPAR.angle.data(:,1), "color", "r");
plot(outPAR.u.time, outPAR.position.data(:,1), "color", "b");
hold off
title("Parallel PID controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])

subplot(antalFigs,1,2)
hold on 
plot(outPAR.u.time, outPAR.u.data(:,1), "color", "b");
hold off
title("Applied force")
legend("u [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-15 15])

subplot(antalFigs,1,3)
hold on 
plot(outPAR.u.time, outPAR.rpm.data(:,1), "color", "b");
hold off
title("Force converted to motor RPM")
legend("Motor velocity [RPM]", 'Location','northwest')
%xlabel("time")
ylabel("[RPM]")
xlabel('$Time$ [s]','interpreter','latex')
grid on
ylim([-175 175])

x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*150;
set(gcf,'position',[x0,y0,width,height])

% ny

f3 = figure()

min = -2.5;
max = 1.5;
antalFigs = 3

subplot(antalFigs,1,1)
hold on 
plot(outLQG.u.time, outLQG.angle.data(:,1), "color", "r");
plot(outLQG.u.time, outLQG.position.data(:,1), "color", "b");
hold off
title("LQG controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])

subplot(antalFigs,1,2)
hold on 
plot(outLQG.u.time, outLQG.u.data(:,1), "color", "b");
hold off
title("Applied force")
legend("u [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-15 15])

subplot(antalFigs,1,3)
hold on 
plot(outLQG.u.time, outLQG.rpm.data(:,1), "color", "b");
hold off
title("Force converted to motor RPM")
legend("Motor velocity [RPM]", 'Location','northwest')
%xlabel("time")
ylabel("[RPM]")
xlabel('$Time$ [s]','interpreter','latex')
grid on
ylim([-175 175])

x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*150;
set(gcf,'position',[x0,y0,width,height])

% ny 
f4 = figure()

min = -2.5;
max = 1.5;
antalFigs = 3

subplot(antalFigs,1,1)
hold on 
plot(outLQR.u.time, outLQR.angle.data(:,1), "color", "r");
plot(outLQR.u.time, outLQR.position.data(:,1), "color", "b");
hold off
title("LQR controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])

subplot(antalFigs,1,2)
hold on 
plot(outLQR.u.time, outLQR.u.data(:,1), "color", "b");
hold off
title("Applied force")
legend("u [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-15 15])

subplot(antalFigs,1,3)
hold on 
plot(outLQR.u.time, outLQR.rpm.data(:,1), "color", "b");
hold off
title("Force converted to motor RPM")
legend("Motor velocity [RPM]", 'Location','northwest')
%xlabel("time")
ylabel("[RPM]")
xlabel('$Time$ [s]','interpreter','latex')
grid on
ylim([-175 175])

x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*150;
set(gcf,'position',[x0,y0,width,height])

% ny 
f5 = figure()

min = -2.5;
max = 1.5;
antalFigs = 3

subplot(antalFigs,1,1)
hold on 
plot(outSTATEPID.u.time, outSTATEPID.angle.data(:,1), "color", "r");
plot(outSTATEPID.u.time, outSTATEPID.position.data(:,1), "color", "b");
hold off
title("State feedback PI controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])

subplot(antalFigs,1,2)
hold on 
plot(outSTATEPID.u.time, outSTATEPID.u.data(:,1), "color", "b");
hold off
title("Applied force")
legend("u [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-15 15])

subplot(antalFigs,1,3)
hold on 
plot(outSTATEPID.u.time, outSTATEPID.rpm.data(:,1), "color", "b");
hold off
title("Force converted to motor RPM")
legend("Motor velocity [RPM]", 'Location','northwest')
%xlabel("time")
ylabel("[RPM]")
xlabel('$Time$ [s]','interpreter','latex')
grid on
ylim([-175 175])

x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*150;
set(gcf,'position',[x0,y0,width,height])

% ny 
f6 = figure()

min = -2.5;
max = 1.5;
antalFigs = 3

subplot(antalFigs,1,1)
hold on 
plot(outDLQG.u.time, outDLQG.angle.data(:,1), "color", "r");
plot(outDLQG.u.time, outDLQG.position.data(:,1), "color", "b");
hold off
title("Discrete LQG controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])

subplot(antalFigs,1,2)
hold on 
plot(outDLQG.u.time, outDLQG.u.data(:,1), "color", "b");
hold off
title("Applied force")
legend("u [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-15 15])

subplot(antalFigs,1,3)
hold on 
plot(outDLQG.u.time, outDLQG.rpm.data(:,1), "color", "b");
hold off
title("Force converted to motor RPM")
legend("Motor velocity [RPM]", 'Location','northwest')
%xlabel("time")
ylabel("[RPM]")
xlabel('$Time$ [s]','interpreter','latex')
grid on
ylim([-175 175])

x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*150;
set(gcf,'position',[x0,y0,width,height])


%% NS test 
load ControllerNStest1.mat
outCAS = out;
load ControllerNStest2.mat
outLQG = out;
load ControllerNStest3.mat
outSTATEPI = out;



f1 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outCAS.u_og_uSat.time, outCAS.angle.data(:,1), "color", "r");
plot(outCAS.u_og_uSat.time, outCAS.position.data(:,1), "color", "b");
hold off
title("Cascade PID controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])


subplot(antalFigs,1,2)
hold on 
plot(outCAS.u_og_uSat.time, outCAS.u_og_uSat.data(:,1), "color", "r");
plot(outCAS.u_og_uSat.time, outCAS.u_og_uSat.data(:,2), "color", "b");
hold off
title("Control signal u before and after saturation")
legend("u [N]", "u saturated [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-20 20])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*200;
set(gcf,'position',[x0,y0,width,height])


f2 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outSTATEPI.u_og_uSat.time, outSTATEPI.angle.data(:,1), "color", "r");
plot(outSTATEPI.u_og_uSat.time, outSTATEPI.position.data(:,1), "color", "b");
hold off
title("State Space PI controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])


subplot(antalFigs,1,2)
hold on 
plot(outSTATEPI.u_og_uSat.time, outSTATEPI.u_og_uSat.data(:,1), "color", "r");
plot(outSTATEPI.u_og_uSat.time, outSTATEPI.u_og_uSat.data(:,2), '--', "color", "b");
hold off
title("Control signal u before and after saturation")
legend("u [N]", "u saturated [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-10 10])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*200;
set(gcf,'position',[x0,y0,width,height])


f3 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outLQG.u_og_uSat.time, outLQG.angle.data(:,1), "color", "r");
plot(outLQG.u_og_uSat.time, outLQG.position.data(:,1), "color", "b");
hold off
title("LQG controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])


subplot(antalFigs,1,2)
hold on 
plot(outLQG.u_og_uSat.time, outLQG.u_og_uSat.data(:,1), "color", "r");
plot(outLQG.u_og_uSat.time, outLQG.u_og_uSat.data(:,2), '--', "color", "b");
hold off
title("Control signal u before and after saturation")
legend("u [N]", "u saturated [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-10 10])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*200;
set(gcf,'position',[x0,y0,width,height])

%% Estimation comparasen
load ControllerEstiTest1.mat
outLQG = out;
load ControllerEstiTest2.mat
outDLQG = out;
f1 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outLQG.y.time, outLQG.y.data(:,2), "color", "r");
plot(outLQG.y.time, outLQG.y.data(:,1), "color", "#ab1700");
plot(outLQG.y.time, outLQG.y_noise.data(:,1), "color", "b");
plot(outLQG.y.time, outLQG.y_noise.data(:,2), "color", "#4dbeee");
plot(outLQG.y.time, outLQG.y_estimated.data(:,2), "color", "g");
plot(outLQG.y.time, outLQG.y_estimated.data(:,1), "color", "#008c05");
hold off
title("LQG controller")
legend("\theta [rad]", "P [m]", "\theta + noise [rad]", "P + noise [m]", "\theta_{estimated} [rad]", "P_{estimated} [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
%ylim([-0.080 0.075])
%xlim([0.8 3])

subplot(antalFigs,1,2)
hold on 
plot(outLQG.y.time, outLQG.diff.data(:,2), "color", "b"); %angle
plot(outLQG.y.time, outLQG.diff.data(:,1), "color", "r"); %position
hold off
title("Difference between y and y estimated ")
legend("Angle difference", "Position difference", 'Location','northeast')
%xlabel("time")
ylabel("y - y_{estimated}")
grid on
ylim([-0.02 0.03])
%xlim([0.8 3])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=antalFigs*300;
height=antalFigs*250;
set(gcf,'position',[x0,y0,width,height])


f2 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outLQG.y.time, outLQG.y.data(:,2), "color", "r");
plot(outLQG.y.time, outLQG.y.data(:,1), "color", "#ab1700");
plot(outLQG.y.time, outLQG.y_noise.data(:,1), "color", "b");
plot(outLQG.y.time, outLQG.y_noise.data(:,2), "color", "#4dbeee");
plot(outLQG.y.time, outLQG.y_estimated.data(:,2), "color", "g");
plot(outLQG.y.time, outLQG.y_estimated.data(:,1), "color", "#008c05");
hold off
title("LQG controller")
legend("\theta [rad]", "P [m]", "\theta + noise [rad]", "P + noise [m]", "\theta_{estimated} [rad]", "P_{estimated} [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.080 0.075])
xlim([0.8 3])

subplot(antalFigs,1,2)
hold on 
plot(outLQG.y.time, outLQG.diff.data(:,2), "color", "b"); %angle
plot(outLQG.y.time, outLQG.diff.data(:,1), "color", "r"); %position
hold off
title("Difference between y and y estimated ")
legend("Angle difference", "Position difference", 'Location','northeast')
%xlabel("time")
ylabel("y - y_{estimated}")
grid on
ylim([-0.02 0.03])
xlim([0.8 3])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=antalFigs*300;
height=antalFigs*250;
set(gcf,'position',[x0,y0,width,height])


f3 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outDLQG.y.time, outDLQG.y.data(:,2), "color", "r");
plot(outDLQG.y.time, outDLQG.y.data(:,1), "color", "#ab1700");
plot(outDLQG.y.time, outDLQG.y_noise.data(:,1), "color", "b");
plot(outDLQG.y.time, outDLQG.y_noise.data(:,2), "color", "#4dbeee");
plot(outDLQG.y.time, outDLQG.y_estimated.data(:,2), "color", "g");
plot(outDLQG.y.time, outDLQG.y_estimated.data(:,1), "color", "#008c05");
hold off
title("Discrete LQG controller")
legend("\theta [rad]", "P [m]", "\theta + noise [rad]", "P + noise [m]", "\theta_{estimated} [rad]", "P_{estimated} [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
%ylim([-0.080 0.075])
%xlim([0.8 3])

subplot(antalFigs,1,2)
hold on 
plot(outDLQG.y.time, outDLQG.diff.data(:,2), "color", "b"); %angle
plot(outDLQG.y.time, outDLQG.diff.data(:,1), "color", "r"); %position
hold off
title("Difference between y and y estimated ")
legend("Angle difference", "Position difference", 'Location','northeast')
%xlabel("time")
ylabel("y - y_{estimated}")
grid on
ylim([-0.02 0.03])
%xlim([0.8 3])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=antalFigs*300;
height=antalFigs*250;
set(gcf,'position',[x0,y0,width,height])


f4 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outDLQG.y.time, outDLQG.y.data(:,2), "color", "r");
plot(outDLQG.y.time, outDLQG.y.data(:,1), "color", "#ab1700");
plot(outDLQG.y.time, outDLQG.y_noise.data(:,1), "color", "b");
plot(outDLQG.y.time, outDLQG.y_noise.data(:,2), "color", "#4dbeee");
plot(outDLQG.y.time, outDLQG.y_estimated.data(:,2), "color", "g");
plot(outDLQG.y.time, outDLQG.y_estimated.data(:,1), "color", "#008c05");
hold off
title("Discrete LQG controller")
legend("\theta [rad]", "P [m]", "\theta + noise [rad]", "P + noise [m]", "\theta_{estimated} [rad]", "P_{estimated} [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.080 0.075])
xlim([0.8 3])

subplot(antalFigs,1,2)
hold on 
plot(outDLQG.y.time, outDLQG.diff.data(:,2), "color", "b"); %angle
plot(outDLQG.y.time, outDLQG.diff.data(:,1), "color", "r"); %position
hold off
title("Difference between y and y estimated ")
legend("Angle difference", "Position difference", 'Location','northeast')
%xlabel("time")
ylabel("y - y_{estimated}")
grid on
ylim([-0.02 0.03])
xlim([0.8 3])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=antalFigs*300;
height=antalFigs*250;
set(gcf,'position',[x0,y0,width,height])



%% ADLQG test 
load ControllerNStest11.mat
outDLQG = out;
load ControllerNStest12.mat
outADLQG = out;




f1 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outDLQG.u_og_uSat.time, outDLQG.angle.data(:,1), "color", "r");
plot(outDLQG.u_og_uSat.time, outDLQG.position.data(:,1), "color", "b");
hold off
title("Discrete LQG controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])


subplot(antalFigs,1,2)
hold on 
plot(outDLQG.u_og_uSat.time, outDLQG.u_og_uSat.data(:,1), "color", "r");
plot(outDLQG.u_og_uSat.time, outDLQG.u_og_uSat.data(:,2), "color", "b");
hold off
title("Control signal u before and after saturation")
legend("u [N]", "u saturated [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-20 20])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*200;
set(gcf,'position',[x0,y0,width,height])


f2 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outADLQG.u_og_uSat.time, outADLQG.angle.data(:,1), "color", "r");
plot(outADLQG.u_og_uSat.time, outADLQG.position.data(:,1), "color", "b");
hold off
title("Aggresive Discrete LQG controller controller")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])


subplot(antalFigs,1,2)
hold on 
plot(outADLQG.u_og_uSat.time, outADLQG.u_og_uSat.data(:,1), "color", "r");
plot(outADLQG.u_og_uSat.time, outADLQG.u_og_uSat.data(:,2), '--', "color", "b");
hold off
title("Control signal u before and after saturation")
legend("u [N]", "u saturated [N]", 'Location','northwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-10 10])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*200;
set(gcf,'position',[x0,y0,width,height])


f3 = figure()

min = -2.5;
max = 1.5;
antalFigs = 2

subplot(antalFigs,1,1)
hold on 
plot(outADLQG.u_og_uSat.time, outADLQG.angle.data(:,1), "color", "b");
plot(outDLQG.u_og_uSat.time, outDLQG.angle.data(:,1), "color", "#4DBEEE");
plot(outADLQG.u_og_uSat.time, outADLQG.position.data(:,1), "color", "r");
plot(outDLQG.u_og_uSat.time, outDLQG.position.data(:,1), "color", "#ab1700");
hold off
title("Comparasion between aggressive and regular discrete LQG controller")
legend("\theta_{ADLQG} [rad]", "\theta_{DLQG} [rad]", "P_{ADLQG} [m]", "P_{DLQG} [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([-0.2 0.6])


subplot(antalFigs,1,2)
hold on 
plot(outADLQG.u_og_uSat.time, outADLQG.u_og_uSat.data(:,2), "color", "r");
plot(outDLQG.u_og_uSat.time, outDLQG.u_og_uSat.data(:,2), "color", "b");
hold off
title("Control signal u_{saturation}")
legend("u_{ADLQG} [N]", "u_{DLQG} [N]", 'Location','southwest')
%xlabel("time")
ylabel("u [N]")
grid on
ylim([-9 4])
xlabel('$Time$ [s]','interpreter','latex')
x0=10;
y0=10;
width=700;
height=antalFigs*250;
set(gcf,'position',[x0,y0,width,height])


%% plot example code
min = -1;
max = 6;
antalFigs = 3

subplot(antalFigs,1,1)
hold on 
plot(out.Lin_Plant.time, out.Lin_Plant.data(:,2), "color", "r");
plot(out.Lin_Plant.time, out.Lin_Plant.data(:,1), "color", "b");
hold off
title("Linearized Plant")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([min max])

subplot(antalFigs,1,2)
hold on 
plot(out.simscape.time, out.simscape.data(:,2), "color", "r");
plot(out.simscape.time, out.simscape.data(:,1), "color", "b");
hold off
title("Simscape")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
grid on
ylim([min max])

subplot(antalFigs,1,3)
hold on 
plot(out.Lin_Plant.time, out.motionEqn.data(:,2), "color", "r");
plot(out.Lin_Plant.time, out.motionEqn.data(:,1), "color", "b");
hold off
title("MotionEquation")
legend("\theta [rad]", "P [m]", 'Location','northwest')
%xlabel("time")
ylabel("output y")
xlabel('$Time$ [s]','interpreter','latex')
grid on
ylim([min max])

x0=10;
y0=10;
width=antalFigs*250;
height=antalFigs*150;
set(gcf,'position',[x0,y0,width,height])
