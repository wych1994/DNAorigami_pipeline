clear all
close all
clc

pos_store=cell(1,1);
I=imread('Gallery\nDFSC5_g1.png');
figure;
imshow(I)
H = uicontrol('Style', 'PushButton', ...
    'String', 'Finish',...
    'Callback', 'delete(gcbf)');
particle_idx=0;


while (ishandle(H))
    particle_idx=particle_idx+1;
    roi = drawpolyline('LineWidth',1,'MarkerSize',5);


    
    if isvalid(roi)
        customWait(roi)
        if isvalid(roi)
        pos_store{particle_idx}=roi.Position;
        end
    end
end

pos_table=[];
for i=1:length(pos_store)
    pos_table=[pos_table; pos_store{i}];
end


%% annotation trace for double check
sw=1;
if sw==1
    figure
    imshow(I)
    hold on
    plot(pos_table(:,1),pos_table(:,2),'b.','MarkerSize',20)

    hold on
    plot(pos_table(:,1),pos_table(:,2),'r--','LineWidth',1)
end



function customWait(hROI)

% Listen for mouse clicks on the ROI
l = addlistener(hROI,'ROIClicked',@clickCallback);

% Block program execution
uiwait;

% Remove listener
delete(l);


end
function clickCallback(~,evt)

if strcmp(evt.SelectionType,'shift')
    uiresume;
end

end