function [D d beta fcount, changes] = transform(type,R, D, d, V, U, beta, negIdx, fcount, MST, changes)

    [c n] = size(d);
    
    switch type
        case 'NE' 
            %get the index to the cluster and the point that caused the
            %negative distance
            [clusters, points]=ind2sub([c n],negIdx);
            uniqueClusters = unique(clusters);
            tmp = zeros(c,n);
            
            for i = uniqueClusters
                k = points(clusters == i);
                tmp(i,k) = V(i,:)*V(i,:)' - 2*V(i,k) + 1;
            end
            
            deltaBeta = max(max((-2.*d(negIdx))./tmp(negIdx)));
            d(negIdx) = d(negIdx) + (deltaBeta/2).*tmp(negIdx);
            D = D + deltaBeta * (ones(n)-eye(n));
            beta = beta + deltaBeta;
            
        case 'BS'
            
        case 'SU'
            [clusters, points]=ind2sub([c n],negIdx);
            uniqueClusters = unique(clusters);
            
            %{
            tmp = zeros(c,n);
            
            for i = uniqueClusters
                k = points(clusters == i);
                tmp(i,k) = V(i,:)*V(i,:)' - 2*V(i,k) + 1;
            end
            
            deltaBeta = max(max((-2.*d(negIdx))./tmp(negIdx)));
            d(negIdx) = d(negIdx) + (deltaBeta/2).*tmp(negIdx);
            beta = beta + deltaBeta;
            %}
            
            for clust = uniqueClusters
                fcount(clust) = fcount(clust) + 1;
                
                %[clust, ~]=ind2sub([c n],idx);
                [p, np] = find_prototype(U(clust,:),D, fcount(clust), c);
                cp = find(clusters == clust);
                
                k = points(cp);
                %k = [1:p-1 p+1:n];
                
                %for p = np
                for z = k
                    h = str2num(sprintf('%d%d%d%d',p,z,z,p));
                    
                    if z ~= p && isempty(find(changes == h, 1))
                        %fprintf('Failed point d(%d/%d, %d)=%f\n',clust,p,z,d(clust,z));
                        %DBefore = D(p,z)
                        D(p,z) = su_dist(z,p,R,MST); 
                        D(z,p) = D(p,z);
                        %DAfter = D(p,z)
                        changes = [changes;h];
                    end
                %end
                end
                
            end
            d(negIdx) = d(negIdx) + -1*min(d(negIdx));
            
        case 'PF'
            
        case 'EF'
            
        case 'LF'
        
        
    end
end

