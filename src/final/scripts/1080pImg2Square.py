import os
import cv2
os.system('cls')

maxs = 1080
sizes = [108, 120, 135, 180, 216, 270, 360, 540, 1080]

for size in sizes:
    path1 = "D:/Note_Database/Subject/DIP Digital Image Processing/DIP_Code/src/final/data/MC9/1920x1080"
    path2 = "D:/Note_Database/Subject/DIP Digital Image Processing/DIP_Code/src/final/data/MC9/{0}x{1}".format(
        size, size)
    os.system('mkdir "' + path2 + '"')

    f1 = []
    ft1 = []
    ft2 = []
    for (dirpath, dirnames, filenames) in os.walk(path1):
        f1.extend(filenames)
        break

    length = len(f1)
    for i in range(length):
        if filenames[i].endswith('.png'):
            command1 = os.path.join(path1, filenames[i])
            command2 = os.path.join(path2, filenames[i])
            ft1.append(command1)
            ft2.append(command2)
            # os.system('"' + command + '"')
    f1 = ft1
    f2 = ft2

    for i in range(length):
        print(f1[i])
        print(f2[i])
        img = cv2.imread(f1[i])
        cropimg = img[0:maxs, 420:maxs+420]  # crop square
        sizeimg = cv2.resize(cropimg, (size, size),
                             interpolation=cv2.INTER_AREA)
        # cv2.imshow('image', sizeimg)
        # cv2.waitKey(0)
        # cv2.destroyAllWindows()
        cv2.imwrite(f2[i], sizeimg)
