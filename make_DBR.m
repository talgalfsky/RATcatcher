function [index, width] = make_DBR(npair, wpair, N)

index = npair;
width = wpair;

for i = 1:(ceil(N)-1)
    index = [npair; index];
    width = [wpair width];
end

index = index(length(width)-length(wpair)*N+1:end,:);
width = width(length(width)-length(wpair)*N+1:end);