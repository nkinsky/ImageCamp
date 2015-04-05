% function[] = manual_reg_byneuron(SignalTrace_base,SignalTrace_reg)

base_signalfile = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangle\SignalTrace.mat';
reg_signalfile = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangular plastic tub\SignalTrace.mat';

SignalTrace_base = importdata(base_signalfile);
SignalTrace_reg = importdata(reg_signalfile);

AllIC_base = zeros(size(SignalTrace_base.ThreshIC{1}));
for j = 1:size(SignalTrace_base.ThreshIC,2)
    AllIC_base = AllIC_base | SignalTrace_base.ThreshIC{j};
    
end

AllIC_reg = zeros(size(SignalTrace_reg.ThreshIC{1}));
for j = 1:size(SignalTrace_reg.ThreshIC,2)
    AllIC_reg = AllIC_reg | SignalTrace_reg.ThreshIC{j};
    
end

figure
h1 = subplot(1,2,1); imagesc(AllIC_base); title('Base Image Cells');
h2 = subplot(1,2,2); imagesc(AllIC_reg); title('Reg Image Cells');

disp('Select Center of Base Image Cells to use as reference')
[xbase, ybase] = getpts(h1);
xvec = [ybase xbase];
axes(h1); hold on;
for j = 1:length(xbase)
%     plot(xbase(j),ybase(j),'*')
    text(xbase(j)+10,ybase(j)-15,num2str(j)); % NRK Note - set this to non-black values for cell manual registration
    
    % Get closest COMs of cells to use
    temp = cellfun(@(a) sqrt((xvec(j,:)-a)*(xvec(j,:)-a)'), SignalTrace_base.GoodCom);
    base_refpoints(j,1) = SignalTrace_base.GoodCom{find(min(temp) == temp)}(2);
    base_refpoints(j,2) = SignalTrace_base.GoodCom{find(min(temp) == temp)}(1);
end
plot(base_refpoints(:,1),base_refpoints(:,2),'g*')
hold off

disp('Select Center of Registered Image Cells to use as a reference')
[xreg, yreg] = getpts(h2);
uvec = [yreg xreg];
axes(h2); hold on;
for j = 1:length(xreg)
%     plot(xreg(j),yreg(j),'*')
    text(xreg(j)+10,yreg(j)-15,num2str(j));
    % Get closest COMs of cells to use
    temp2 = cellfun(@(a) sqrt((uvec(j,:)-a)*(uvec(j,:)-a)'), SignalTrace_reg.GoodCom);
    reg_refpoints(j,1) = SignalTrace_reg.GoodCom{find(min(temp2) == temp2)}(2);
    reg_refpoints(j,2) = SignalTrace_reg.GoodCom{find(min(temp2) == temp2)}(1);
    
end
plot(reg_refpoints(:,1),reg_refpoints(:,2),'g*')
hold off

for j = 1:300; 
    size(SignalTrace_reg.ThreshIC{j}) 
end

% end
