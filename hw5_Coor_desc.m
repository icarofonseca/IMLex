clear
clc

u = 1;
v = 1;
eta = 0.1;

error = (u*exp(v)-2*v*exp(-u))^2;

for i=1:15
    du_error = 2*(exp(v)+2*v*exp(-u))*(u*exp(v)-2*v*exp(-u));
    u=u-eta*du_error;
    dv_error = 2*(u*exp(v)-2*exp(-u))*(u*exp(v)-2*v*exp(-u));
    v=v-eta*dv_error;
    error = (u*exp(v)-2*v*exp(-u))^2;
end

error