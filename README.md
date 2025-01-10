# **Computing Surface Integrals**

## **Overview**
The trained surrogate models can predict aerodynamic surface quantities for a given set of 22 control point coordinates of the aerofoil with less than **1% relative error**, even for models trained with the least number of training cases. Given the robust stability of models trained with larger datasets, they can be used for predictions effectively while acknowledging the limitations of models trained under data scarcity.

Using these surrogate models, **surface integral quantities** such as **Lift** and **Drag** are computed based on the values of **pressure** $p$, **shear stress** $\tau_1$ and $\tau_2$ at the corresponding nodes on the aerofoil wall.

---

## **1. Computing Edge Integral for a Scalar-Valued Function**

### **Mathematical Formulation**
The integral of a scalar field $f$ (representing pressure) over an edge of a surface is computed using linear shape functions.

Each edge is parameterized by the nodal coordinates as:
![equation](https://latex.codecogs.com/svg.image?\color{White}\Gamma(\xi)=\begin{bmatrix}x\\y\end{bmatrix}=N_1(\xi)\begin{bmatrix}x_1\\y_1\end{bmatrix}+N_2(\xi)\begin{bmatrix}x_2\\y_2\end{bmatrix})
where:
- ![equation](https://latex.codecogs.com/svg.image?\color{White}N_1(\xi)=\frac{1-\xi}{2})  
- ![equation](https://latex.codecogs.com/svg.image?\color{White}N_2(\xi)=\frac{1+\xi}{2})  
and $\xi \in [-1, 1]$ is the parametric coordinate along the edge.

---

### **1.1 Edge $\Gamma_1$**
For the edge $\Gamma_1$, bounded by coordinates $(x_1, y_1) = (3, 0)$ and $(x_2, y_2) = (2, 1)$:
![equation](https://latex.codecogs.com/svg.image?\color{White}\Gamma_1(\xi)=N_1(\xi)\begin{bmatrix}3\\0\end{bmatrix}+N_2(\xi)\begin{bmatrix}2\\1\end{bmatrix}=\begin{bmatrix}\frac{5-\xi}{2}\\\frac{1+\xi}{2}\end{bmatrix})

The derivatives with respect to $\xi$ are:
![equation](https://latex.codecogs.com/svg.image?\color{White}\frac{dx}{d\xi}=-\frac{1}{2},\quad\frac{dy}{d\xi}=\frac{1}{2})

The Jacobian is computed as:
![equation](https://latex.codecogs.com/svg.image?\color{White}\left\|\Gamma_1'(\xi)\right\|=\sqrt{\left(\frac{dx}{d\xi}\right)^2+\left(\frac{dy}{d\xi}\right)^2}=\frac{\sqrt{2}}{2})

---

### **1.2 Surface Integral of Pressure Over Edge $\Gamma_1$**
The surface integral for the scalar field $f$ (representing pressure) along edge $\Gamma_1$ is:
![equation](https://latex.codecogs.com/svg.image?\color{White}I_1=\int_{\Gamma_1}f(x,y)\,ds=\int_{-1}^{1}f(\Gamma_1(\xi))\left\|\Gamma_1'(\xi)\right\|d\xi)

The scalar field $f(\Gamma_1(\xi))$ is interpolated as:
![equation](https://latex.codecogs.com/svg.image?\color{White}f(\Gamma_1(\xi))=f_1N_1(\xi)+f_2N_2(\xi))

Substituting into the integral expression:
![equation](https://latex.codecogs.com/svg.image?\color{White}I_1=\int_{-1}^{1}\left(f_1\frac{1-\xi}{2}+f_2\frac{1+\xi}{2}\right)\cdot\frac{\sqrt{2}}{2}d\xi)

For $f_1 = 1$ and $f_2 = 2$:
![equation](https://latex.codecogs.com/svg.image?\color{White}I_1=\frac{3\sqrt{2}}{2})

---

## **2. Computing Lift and Drag Coefficients**

The **lift** and **drag** coefficients are computed by integrating the pressure and shear stress along the airfoil surface.

---

### **2.1 Lift and Drag Coefficients Formulation**
The lift and drag coefficients $C_l$ and $C_d$ are defined as:
![equation](https://latex.codecogs.com/svg.image?\color{White}C_l=\dfrac{1}{q_{\infty}S_{\Gamma}}\int_{\Gamma}\bm{\sigma}_j^wn_j^{\infty}d\bm{x})
![equation](https://latex.codecogs.com/svg.image?\color{White}C_d=\dfrac{1}{q_{\infty}S_{\Gamma}}\int_{\Gamma}\bm{\sigma}_j^wt_j^{\infty}d\bm{x})
where:
- $\bm{\sigma}_j^w$ is the wall stress tensor.
- $n_j^{\infty}$ and $t_j^{\infty}$ are the normal and tangential vectors at the boundary.
- $q_{\infty}$ is the free-stream dynamic pressure:
  ![equation](https://latex.codecogs.com/svg.image?\color{White}q_{\infty}=\frac{1}{2}\rho_{\infty}u_{\infty}^2)
- $S_{\Gamma}$ is the reference area:
  ![equation](https://latex.codecogs.com/svg.image?\color{White}S_{\Gamma}=L_{ref})

---

### **2.2 Normal and Tangential Vectors**
The surface normal and tangential vectors are expressed as:
![equation](https://latex.codecogs.com/svg.image?\color{White}n_j^{\infty}=\begin{bmatrix}-\sin(\alpha)\\\cos(\alpha)\end{bmatrix})
![equation](https://latex.codecogs.com/svg.image?\color{White}t_j^{\infty}=\begin{bmatrix}\cos(\alpha)\\\sin(\alpha)\end{bmatrix})

---

### **2.3 Wall Stress Tensor Components**
The stress tensor components $\sigma_i^w$ are:
![equation](https://latex.codecogs.com/svg.image?\color{White}\sigma_i^w=-p\delta_{ij}+\tau_{ij})

The individual components are:
![equation](https://latex.codecogs.com/svg.image?\color{White}\sigma_1^w=-pn_1+\tau_{11}n_1+\tau_{12}n_2)
![equation](https://latex.codecogs.com/svg.image?\color{White}\sigma_2^w=-pn_2+\tau_{12}n_1+\tau_{22}n_2)

---

## **3. Algorithm for Computing Lift and Drag Coefficients**

**Input:** Wall data file (`WallValues.dat`) containing $(x_i, y_i)$, $p$, $\tau_1$, $\tau_2$, $n_1$, $n_2$, and angle of attack $\alpha$.

**Output:** Lift coefficient $C_l$ and drag coefficient $C_d$.

1. **Initialize constants:**
   ![equation](https://latex.codecogs.com/svg.image?\color{White}u_{\infty}=1,\quad\rho_{\infty}=1,\quad{q}_{\infty}=0.5,\quad{S}_{\Gamma}=1)
   
2. **Extract data:** Read $(x_i, y_i)$, $p$, $\tau_1$, $\tau_2$, $n_1$, $n_2$.

3. **Loop over surface edges:**
   - Compute the Jacobian:
     ![equation](https://latex.codecogs.com/svg.image?\color{White}J=\frac{1}{2}\sqrt{(x_{i+1}-x_i)^2+(y_{i+1}-y_i)^2})
   - Compute the stress tensor:
     ![equation](https://latex.codecogs.com/svg.image?\color{White}\sigma_{1j}^w=-\frac{p_i+p_{i+1}}{2}n_1+\frac{\tau_{1_i}+\tau_{1_{i+1}}}{2})
     ![equation](https://latex.codecogs.com/svg.image?\color{White}\sigma_{2j}^w=-\frac{p_i+p_{i+1}}{2}n_2+\frac{\tau_{2_i}+\tau_{2_{i+1}}}{2})

4. **Compute lift and drag contributions:**
   - Add contributions to total lift:
     ![equation](https://latex.codecogs.com/svg.image?\color{White}\text{integral\_lift}+=\left(\sigma_{1j}^wn_1+\sigma_{2j}^wn_2\right)J)
   - Add contributions to total drag:
     ![equation](https://latex.codecogs.com/svg.image?\color{White}\text{integral\_drag}+=\left(\sigma_{1j}^wt_1+\sigma_{2j}^wt_2\right)J)

5. **Calculate lift and drag coefficients:**
   ![equation](https://latex.codecogs.com/svg.image?\color{White}C_l=\frac{\text{integral\_lift}}{q_{\infty}S_{\Gamma}},\quad{C_d}=\frac{\text{integral\_drag}}{q_{\infty}S_{\Gamma}})

---

This concludes the methodology for computing lift and drag using surface integrals.
