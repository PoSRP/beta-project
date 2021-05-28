%% convert UR recorded orientation  trajectory to RPY
clc
clear all
close all

load PlantTestData.mat

ans.Disturbance
%% Convert orientation
loadedData = Data(ans)

%% Time
dt = 1/500;
time= length(Pos);
T= time*dt;
Time = 0:dt:T;
Time = Time(:,1:length(Pos))';

%% plot 
%Positions
figure(1)
subplot(3,1,1)
H1=plot(Time,Pos(:,1),'LineWidth',1.5);
ylabel('$X_{pos}$ [m]','interpreter','latex')
legend([H1],'UR trajectory','Location','southwest');
grid on

subplot(3,1,2)
plot(Time,Pos(:,2),'LineWidth',1.5)
ylabel('$Y_{pos}$ [m]','interpreter','latex')
grid on

subplot(3,1,3)
plot(Time,Pos(:,3),'LineWidth',1.5)
ylabel('$Z_{pos}$ [m]','interpreter','latex')
xlabel('$Time$ [s]','interpreter','latex')
grid on

%% size of the plot

xSize = 20; ySize = 18; % 1 plot
% % xSize = 20; ySize = 18; % 2 plota
% %  xSize = 20; ySize = 22.5; % 3 plota
% % % xSize = 20; ySize = 40; % 4 plota
xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize])

