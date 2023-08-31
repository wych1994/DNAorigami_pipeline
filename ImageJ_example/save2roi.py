import roifile
import pandas as pd
import numpy as np

# n_col=11
# n_raw=11
condition_name='nDFSC35_X_v3'
csv_name='particle-'+condition_name+'DLC_resnet50_TEM_angle_varyBKGOct30shuffle1_50000.csv'
data=pd.read_csv(csv_name)
data=data.values.tolist()
roi_store=[]
particle_num=len(data)-2
n_col=int(np.ceil(np.sqrt(particle_num)))

###for 3 point hinge structures
for p_idx_raw in range(1,50):
    for p_idx_col in range(1,n_col+1):
        p_idx=p_idx_col+(p_idx_raw-1)*n_col
        if p_idx<=particle_num:
            pose=data[p_idx+1][1:]
            pose = [eval(i) for i in pose]
            pose_x = [pose[0], pose[3], pose[6]]
            pose_y = [pose[1], pose[4], pose[7]]
            pose_x = [x+200*(p_idx_col-1) for x in pose_x]
            pose_y = [x+200*(p_idx_raw-1) for x in pose_y]
            p1 = [pose_x[0], pose_y[0]]
            p2 = [pose_x[1], pose_y[1]]
            p3 = [pose_x[2], pose_y[2]]
            roi= roifile.ImagejRoi.frompoints(
                [p1,p2,p3], name=str(p_idx)
            )
            roi.roitype = roifile.ROI_TYPE.ANGLE
            roi_store.append(roi)
        else:
            break
roifile.roiwrite(condition_name+'.zip', roi_store)
# roi.tofile('test.roi')

'''
###for 3 point hinge structures
for p_idx_raw in range(1,n_raw):
    for p_idx_col in range(1,n_col+1):
        p_idx=p_idx_col+(p_idx_raw-1)*n_col
        pose=data[p_idx+1][1:]
        pose = [eval(i) for i in pose]
        pose_x = [pose[0], pose[3], pose[6]]
        pose_y = [pose[1], pose[4], pose[7]]
        pose_x = [x+200*(p_idx_col-1) for x in pose_x]
        pose_y = [x+200*(p_idx_raw-1) for x in pose_y]
        p1 = [pose_x[0], pose_y[0]]
        p2 = [pose_x[1], pose_y[1]]
        p3 = [pose_x[2], pose_y[2]]
        roi= roifile.ImagejRoi.frompoints(
            [p1,p2,p3], name=str(p_idx)
        )
        roi.roitype = roifile.ROI_TYPE.ANGLE
        roi_store.append(roi)
roifile.roiwrite('nDFSB_X_v2.zip', roi_store)
# roi.tofile('test.roi')
'''
'''
roi= roifile.ImagejRoi.frompoints(
    [[50,50], [500, 500], [50,1000]], name='abc'
)
roi.roitype = roifile.ROI_TYPE.ANGLE

roi2= roifile.ImagejRoi.frompoints(
    [[500,50], [100, 500], [500,1000]], name='123'
)
roi2.roitype = roifile.ROI_TYPE.ANGLE
 # roi.tofile('issue6.roi')

roifile.roiwrite('set.zip', [roi,roi2])
roi.plot()
'''
'''
count=0
for p_idx_raw in range(1,n_raw):
    for p_idx_col in range(1,n_col+1):
        p_idx = p_idx_col+(p_idx_raw-1)*n_col
        pose = data[p_idx+1][1:]
        pose = [eval(i) for i in pose]
        pose_x = [pose[0], pose[3], pose[6], pose[9]]
        pose_y = [pose[1], pose[4], pose[7], pose[10]]
        pose_x = [x+200*(p_idx_col-1) for x in pose_x]
        pose_y = [x+200*(p_idx_raw-1) for x in pose_y]
        for p_idx4 in range(4):
            p_pose = [pose_x[0+p_idx4], pose_y[0+p_idx4]]

            roi= roifile.ImagejRoi.frompoints(
                [p_pose], name=str(count)
            )
            count += 1
            roi.roitype = roifile.ROI_TYPE.POINT
            roi_store.append(roi)
roifile.roiwrite('LC3RC3x2_roiset.zip', roi_store)
# roi.tofile('test.roi')
'''