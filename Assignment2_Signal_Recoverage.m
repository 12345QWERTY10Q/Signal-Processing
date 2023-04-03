clc;
clear;
y= readmatrix("Desktop\cityu\Statistics\2\Conpressed Signal.xlsx");
X= readmatrix("Desktop\cityu\Statistics\2\Complete profile.xlsx");
Index=readmatrix("Desktop\cityu\Statistics\2\index.xlsx");
%%
plot(X,1:128)
hold on
%%
% Find MeasurementMatrix
% Process 'Index' in the Table3'Sparse measurement'
MeasurementMatrix=zeros(10,128);
for i=1:10
MeasurementMatrix(i,Index(i)) =1;
end
A=MeasurementMatrix*dctmtx(128)';
%%
%Iteration Time
Iteration_Time=10;
%%
Sparse_Signal=OMP(y,A,Iteration_Time);
X_=dctmtx(128)'*Sparse_Signal;
plot(X_,1:128)
xlabel('Power')
ylabel('Time')
ylim([0 128])
title("Signal Comparison");
legend( "Original Signal","Recover Signal");
%%
function [Sparse_Signal]=OMP(y,A,t)
    [M,N]=size(A);                           
    Sparse_Signal=zeros(N,1);                        
    Weight=zeros(N,1);
    A_Container=zeros(M,t);                           
    Selected_Vector_Position=zeros(1,t);                    
    Residual=y;
        %Iteration in a given number
    for ii=1:t                                 
        fprintf('Iteration Time：%d\n',ii);
        %1.Select Vector
        product=A'*Residual;                                            
        [~,Select_Vector_Position]=max(abs(product));
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
        %%4.1 Update Residual
        Residual=y-A_Container(:,1:ii)*Weight;           
        fprintf('Residual:');
        disp(Residual');
        %4.2 Judgement 'Whether to break'
        error=sum(Residual.^2);                    
        fprintf('Residual=%d\n',error);
        if error < 1e-6                        
            disp(ii);
            break;  
        end
    end
    %% Update Recover Signal
    disp('Summary')
    fprintf('Selected_Vector_Position：')
    disp(Selected_Vector_Position);
    fprintf('Weight：');
    disp(Weight');
    fprintf('Sparse_Signal：');
    %Load Weight According to Position
    Sparse_Signal(Selected_Vector_Position)=Weight;  
    disp(Sparse_Signal');
 end 
