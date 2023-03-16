
%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Copyright                        %
%     This code is developed by Jianhui Li    %
%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear
close all

%������ϵ��
Ktc=958.8599 ; %����������ϵ��
Krc=250.8633 ; %����������ϵ��
Kte=15.7580  ; %�����п���ϵ��
Kre=19.4337  ; %�����п���ϵ��
Kac=146.3614 ; %����������ϵ��
Kae=18.2075  ; %�����п���ϵ��

%������ʽ
operation=1;  %˳ϳ

%���߼���
df=25;        %����ֱ��
beta=1/4*pi;  %������
Nt=2;         %���߳���
phip=2*pi/Nt; %���߳ݼ��

%��������
axis_immersion = 3;  %a�������� mm
radial_immersion = 25;%�п� /mm
speed=6000;          %����ת�� rpm
feed=900;            %�����ٶ� mm/min
c=feed/Nt/speed;     %c������ mm/��
phis = acos((df/2 - radial_immersion)/(df/2));  % (rad) the absolute angle of cutting ����Ƕ�
if operation == 0
    phist = 0;       % rad ��ϳ          %�����
    phiex = phist + phis;                  %�г���
else
    phiex = pi;      % rad ˳ϳ
    phist = phiex - phis;
end

%�������
t=0.1;          %����ʱ�� s
rotation=speed/60*t; %��תȦ��
step_r=0.01;    %�ǻ��ֲ���
step_b=0.01;    %������ֲ���
K=2*pi*rotation/step_r ;  %������ֲ���
L=axis_immersion/step_b ; %������ֲ���


Fx=zeros(1,floor(K));%floor ����ȡ��
Fy=zeros(1,floor(K));
Fz=zeros(1,floor(K));
Ft=zeros(1,floor(K));

Fk=zeros(1,floor(K));
T=zeros(1,floor(K));
step_h=zeros(1,length(L));%
phi_i =zeros(1,floor(K));
Time=zeros(1,floor(K));

for m=1:floor(K)
    phi_i(m)=phist+(m-1)*step_r;    %�����۵ײ��еĽӴ���
    while phi_i(m)>2*pi
        phi_i(m)=phi_i(m)-2*pi;%ѭ��
    end
    for i=1:Nt                      %��i����
        R1=phi_i(m)+(i-1)*phip;
        R2=R1;

        for j=1:L                               %��i�����ϵĵ�j������΢Ԫ
            step_h(j)=(j-1)*step_b;             %��j������΢Ԫ������߶�
            R2=R1-2*tan(beta)/df*step_h(j);     %����������������ĽӴ��Ǳ仯
            
            if R2>2*pi
                R2=R2-2*pi;             %��i�������ϵ�j��΢Ԫ��ʵ�ʽӴ��Ƕ�
            end
            
            if  phist<=R2&&R2<=phiex    %�жϵ���΢Ԫ�Ƿ��������
                h=c*sin(R2);            %˲ʱ���������ÿ�ݽ�����֮��Ĺ�ϵ
                
                ft=step_b*(Ktc*h+Kte);  %������΢Ԫ
                fr=step_b*(Krc*h+Kre);  %������΢Ԫ
                fa=step_b*(Kac*h+Kae);  %������΢Ԫ
                
                fy=-ft*cos(R2)-fr*sin(R2);
                fx=ft*sin(R2)-fr*cos(R2);
                fz=fa;
                
                Fx(m)=Fx(m)+fx;
                Fy(m)=Fy(m)+fy;
                Fz(m)=Fz(m)+fz;
                Ft(m)=Ft(m)+ft;
                
            end
        end%next j ��һ��΢Ԫ
    end%next i ��һ������
Fk(m)=sqrt(Fx(m)^2+Fy(m)^2+Fz(m)^2); %��������
T(m)=df/2*Ft(m)/1e3 ; %��������
Time(m)=(m-1)*t/floor(K);
end%next m ��һʱ�̵Ĳο�ת��
plot(Time,Fx,'r')
hold on
plot(Time,Fy,'g')
hold on
plot(Time,Fz,'b')
hold on
% plot(Time,Fk,'k')
% hold on
% plot(Time,T,'m')
% hold on
legend('Fx','Fy','Fz')
