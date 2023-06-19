import matplotlib.pyplot as plt
import numpy as np
import scipy as sp

# Data obtained using vks_extraction_h2+.sh
Vks1eV=np.array([-27.92236597, -27.87643337, -27.83054344, -27.96809299, -28.01389160,])
occ1eV=np.array([0.52302810, 0.52970306, 0.53638244, 0.51633850, 0.50965977,])

Vks2eV=np.array([-27.92302772, -27.86992248, -27.81683138, -27.97588766, -28.02878411,])
occ2eV=np.array([0.52307522, 0.53074523, 0.53842017, 0.51538899, 0.50770847,])

Vks3eV=np.array([-27.92369017, -27.86084960, -27.79798455, -27.98620518, -28.04860953,])
occ3eV=np.array([0.52312228, 0.53214242, 0.54117012, 0.51408599, 0.50503642,])

Vks4eV=np.array([-27.92435330, -27.84754563, -27.77042423, -28.00076067, -28.07697532,])
occ4eV=np.array([0.52316929, 0.53412693, 0.54508078, 0.51219005, 0.50119539,])

Vks5eV=np.array([-27.92501709, -27.82645468, -27.72746119, -28.02296566, -28.12054136,])
occ5eV=np.array([0.52321624, 0.53718421, 0.55116191, 0.50921699, 0.49518595,])

Vks6eV=np.array([-27.92568154, -27.78871910, -27.65017901, -28.06181482, -28.19688601,])
occ6eV=np.array([0.52326312, 0.54256212, 0.56187446, 0.50393014, 0.48447606,])

#Vks7eV=np.array([-27.92634660, -24.27958231, -24.28080604, -28.14757884,])
#occ7eV=np.array([0.52330994, 0.99426160, 0.99432586, 0.49191403,])

Vks682eV=np.array([-27.92622683, -27.72506016, -27.51989295, -28.12535495, -28.32410040,])
occ682eV=np.array([0.52330152, 0.55144021, 0.57973318, 0.49507844, 0.46638445,])

Vks8eV=np.array([-27.92701226, -24.27033990, -24.26925170, -26.80198711, -26.76126604,])
occ8eV=np.array([0.52335669, 0.99532212, 0.99541128, 0.00755080, 0.00724690,])

Vks9eV=np.array([-27.92767850, -24.26876871, -24.26950307, -26.61725606, -26.60197042,])
occ9eV=np.array([0.52340338, 0.99580131, 0.99584802, 0.00617019, 0.00597875,])

Vks10eV=np.array([-27.92834531, -24.26731551, -24.27026084, -26.52731986, -26.53374682,])
occ10eV=np.array([0.52345000, 0.99612065, 0.99614420, 0.00529116, 0.00515631,])

#We've ommitted 7. It broke.
pots = np.array([Vks1eV, Vks2eV, Vks3eV, Vks4eV, Vks5eV, Vks6eV, Vks682eV, Vks8eV, Vks9eV, Vks10eV])
occs = np.array([occ1eV, occ2eV, occ3eV, occ4eV, occ5eV, occ6eV, occ682eV, occ8eV, occ9eV, occ10eV])

#for i in range(len(pots)):
#    plt.plot(occs[i],pots[i], 'ko')
#    plt.show()

U_in = [1.,2.,3.,4.,5.,6.,6.82,]
f_Hxc = []
for i in range(len(U_in)):
    reg = sp.stats.linregress(occs[i],pots[i])
    f = reg.slope
    f_Hxc.append(f)
    print(f)

# Plot f_Hxc(U_in)
plt.plot(U_in, f_Hxc, 'ko', label='Calculated')

# Plot linear fit
reg = sp.stats.linregress(U_in, f_Hxc)
def f(x):
    return (reg.slope * x) + reg.intercept

# Need more data points to get intercept
x = np.arange(0,10,1)

# Make linear regression line
f_regressed = []
for i in range(len(x)):
    f_regressed.append(f(x[i]))

plt.plot(x, f_regressed, label='Linear Regression')

# Plot line with slope of 1 through origin
plt.plot(x,x, label=r'$f(U_{\mathrm{in}}) = U_{\mathrm{in}}$')

# Plot the point of intersection solved by y = x = m*x + c
plt.plot((reg.intercept)/(1.0 - reg.slope),(reg.intercept)/(1.0 - reg.slope), 'go', label='Intersection')

print("Point of intersection is "+ str((reg.intercept)/(1.0 - reg.slope)))

plt.xlabel(r"Applied input Hubbard parameter $U_{\mathrm{in}}$")
plt.ylabel(r"Subspace-averaged Hxc interaction calculated at DFT+$U_{\mathrm{in}}$")
plt.grid()
plt.legend()
plt.savefig("f-Hxc-U_in-H2+.svg",transparent=True)
plt.show()
