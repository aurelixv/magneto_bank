import sys
import base64
import time
import cv2
import os
import numpy as np

# H = np.loadtxt(open("H-1.txt", "rb"), delimiter=",")
# np.save("np-H-1", H)

input_signal = np.loadtxt(open(sys.argv[1], "rb"), delimiter=",")
start_time = time.time()

print("Reconstruindo a imagem")

H = np.load("np-H-1.npy")

width = 60
height = 60

Ht = H.transpose()
f = np.zeros((width*height,), dtype=np.float64)

r = input_signal - np.dot(H, f)
p = np.dot(Ht, r)

for i in range (15):
    alpha = np.dot(r.transpose(), r) / np.dot(p.transpose(), p)
    f += np.dot(alpha, p)
    if i == 14:
        break
    rplus = r - np.dot(np.dot(alpha, H), p)
    beta = np.dot(rplus.transpose(), rplus) / np.dot(r.transpose(), r)
    pplus = np.dot(Ht, rplus) + np.dot(beta, p)
    r = rplus
    p = pplus

f.resize(width, height)

filename = str(time.time()) + ".png"
cv2.normalize(f, f, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_64F)
cv2.imwrite("./public/" + filename, f)

print("--- Tempo: %s segundos ---" % (time.time() - start_time))
os.system("echo " + filename + " > logg")
