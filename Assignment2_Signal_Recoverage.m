clc;
clear;
%%
% Background
y= readmatrix("Desktop\cityu\Statistics\2\Conpressed Signal.xlsx");
X= readmatrix("Desktop\cityu\Statistics\2\Complete profile.xlsx");
Index=readmatrix("Desktop\cityu\Statistics\2\index.xlsx");
%%
% Iteration Time
Iteration_Time=3;
%%
% Find     Dictionary_Matrix
% 1.Find   Measurement_Matrix: Process 'Index' in the Table3'Sparse measurement'
% 2.Define Sparse_Matrix:      DCT Basis Matrix
MeasurementMatrix=zeros(10,128);
for i=1:10
MeasurementMatrix(i,Index(i)) =1;
end
A=MeasurementMatrix*dctmtx(128)';
%%
% Figure
tiledlayout(1,6)
nexttile
plot(X,1:128,'Color',[0.85, 0.33, 0.10])
xlabel('Power')
ylabel('Time')
ylim([0 128])
title("Original Signal");
legend( "Original Signal")
%%
% Initial Preperation
    [M,N]=size(A);
    Product=zeros(1,N);
    Sparse_Signal=zeros(N,1);                        
    Weight=zeros(N,1);
    A_Container=zeros(M,Iteration_Time);                           
    Selected_Vector_Position=zeros(1,Iteration_Time);                    
    Residual=y;
    %Iteration
    ii=1;
    while ii<=Iteration_Time 
        AT=A';
        fprintf('Iteration Time：%d\n',ii);
        %1.Select Vector
        for iii= 1:N 
        Product(iii)=(AT(iii,:)*Residual)./(sqrt(Residual'*Residual)*sqrt(AT(iii,:)*A(:,iii)));   
        end
        [~,Select_Vector_Position]=max(abs(Product));
        %2.1 Adding   ->  A_Container
        %2.2 Deleting ->  A   
        A_Container(:,ii)=A(:,Select_Vector_Position); 
        A(:,Select_Vector_Position)=zeros(M,1); 
        fprintf('A_Container：\n')
        disp(A_Container);
        %Display Selected Vector Position
        Selected_Vector_Position(ii)=Select_Vector_Position;                     
        fprintf('Selected_Vector_Position：');
        disp(Selected_Vector_Position);
        %3.Calculate Weight
        Weight=(A_Container(:,1:ii)'*A_Container(:,1:ii))^(-1)*A_Container(:,1:ii)'*y;  
        fprintf('Weight：');
        disp(Weight');
        %4.Loading Weight
        DCT=dctmtx(128)';
        Component=DCT(:,Selected_Vector_Position(ii))*Weight(ii);
        %5.Plot Component
        nexttile
        plot(Component,1:128,'Color',[0.00, 0.45, 0.74])
        xlabel('Power')
        ylabel('Time')
        ylim([0 128])
        title("Signal Component");
        legend('Component');
        %6.1 Update Residual
        Residual=y-A_Container(:,1:ii)*Weight;           
        fprintf('Residual:');
        disp(Residual');
        %6.2 Judgement 'Whether to break'
        error=sum(Residual.^2);                    
        fprintf('Residual=%d\n',error);
        if error < 1e-6                        
            disp(ii);
            break;  
        end
        ii=ii+1;
    end
%% 
%Summary
    disp('Summary')
    fprintf('Selected_Vector_Position：')
    disp(Selected_Vector_Position);
    fprintf('Weight：');
    disp(Weight');
    fprintf('Sparse_Signal：');
    %Load Weight According to Position
    Sparse_Signal(Selected_Vector_Position)=Weight;  
    disp(Sparse_Signal');
%%
% Plot "Recover Signal"
nexttile
Recover_Signal=dctmtx(128)'*Sparse_Signal;
plot(Recover_Signal,1:128,'Color',[0.00, 0.45, 0.74])
xlabel('Power')
ylabel('Time')
ylim([0 128])
title("Recover Signal");
legend( "Recover Signal")
% Plot Comparsion
nexttile
plot(X,1:128)
hold on
plot(Recover_Signal,1:128)
xlabel('Power')
ylabel('Time')
ylim([0 128])
title("Signal Comparison");
legend( "Original Signal","Recover Signal");
text(3,100,'\rightarrow Overlap','FontSize',15)