figure;
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.32]);
subplot(4,1,4);
plot(time,value1,'Color',[0 70/255 222/255],'LineWidth',5);
hold on;
plot(time,value2,'Color',[1 0 0],'LineWidth',5,'LineStyle','-.');
plot(time,value3,'Color',[0.4940 0.1840 0.5560],'LineWidth',0.5,'Marker','*','MarkerIndices',1:50:length(motion_Timo5(:,7)),'MarkerSize',10);
plot(time,value4,'Color',[0 0 0],'LineWidth',3,'LineStyle',':');
plot(time,value5,'Color',[0 1 0],'LineWidth',2.5);
plot(time,value6,'Color',[1 187/255 0],'LineWidth',1.25);
xlim([0,100]);
ylim([-6 6]);

xlabel('Time [s]','FontName','Times New Roman');
ylabel('Yaw [degree]','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',15);
%legend('FAST','Timo1','Timo2','Timo3','Timo4');
hold off;
box off;