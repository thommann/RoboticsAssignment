import numpy as np
import cv2
import matplotlib
from matplotlib import pyplot as plt
from math import atan2, tan, degrees

print(matplotlib.rcParams['interactive'] == True)

img = cv2.imread('object_images/er7-4.jpg')
width, height = img.shape[1], img.shape[0]
ratio = width / height
dim = (int(500 * ratio), 500)
img = cv2.resize(img, dim)
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(gray, (5, 5), 0)
ret, thresh = cv2.threshold(blurred, 200, 255, cv2.THRESH_BINARY)
contours, hierarchy = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
print(len(contours))

# cv2.drawContours(img, contours, -1, (0, 255, 0), 3)

# loop over the contours
for c in contours:
    # compute the center of the contour, then detect the name of the
    # shape using only the contour
    moment = cv2.moments(c)
    if moment["m00"] == 0:
        continue

    cX = int(moment["m10"] / moment["m00"])
    cY = int(moment["m01"] / moment["m00"])

    # Principle angle 'phi' and slope 'k' = 'tan(phi)'
    phi = atan2(2 * moment["mu11"], (moment["mu20"] - moment["mu02"])) / 2
    k = tan(phi)

    # y - cY = k(x - cX)
    point1 = (0, -int(k * cX) + cY)
    point2 = (int(500 * ratio), int(k * (500 * ratio - cX) + cY))
    points = np.array([point1, point2])
    print(points)

    # Plot the centroid points and principle axis
    cv2.circle(img, (cX, cY), 2, (255, 0, 255), thickness=4)
    plt.text(cX-100, cY-25, f"{cX}, {cY}, {degrees(phi):.1f}°", c=(1, 1, 1), backgroundcolor=(0, 0, 0))
    # cv2.putText(img, f"{cX}, {cY}, {degrees(phi):.1f} deg", (cX-100, cY-10), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 0, 255), 2)
    plt.plot(points[:, 0], points[:, 1], (0, 0, 0))

plt.imshow(img)
plt.savefig('output.png')
# plt.show()
# cv2.imshow('gray', gray)
# cv2.imshow('blurred', blurred)
# cv2.imshow('threshold', thresh)

# k = cv2.waitKey(0)
# if k == 32:
#     cv2.destroyAllWindows()

