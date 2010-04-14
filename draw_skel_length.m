function draw_skel(frame, names, bones, bound_in)
	if (size(frame, 2) == 3)
		markers = frame;
	else
		markers = reshape(frame, 3, prod(size(frame))/3)';
	end
	
	plot3(markers(:,1), markers(:,2), markers(:,3), 'ob', 'LineSmoothing', 'off');
	axis equal;
	new_names = regexprep(names, '^.*:(.*-[xyz])$', '$1');
	base_names = regexprep(new_names(1:3:end), '^(.*)-[xyz]$', '$1');
	%Make sure markers are layed out in an order we approve of:
	assert(min(strcmp(new_names(1:3:end), strcat(base_names, '-x'))) == 1);
	assert(min(strcmp(new_names(2:3:end), strcat(base_names, '-y'))) == 1);
	assert(min(strcmp(new_names(3:3:end), strcat(base_names, '-z'))) == 1);
	clear new_names;
	%Ok! base_names has the basic marker names now:
	hier = { ...
... %stuff on the left:
	'LANK' 'LSHN' 'g' ...
	'LBHD' 'C7' 'g' ...
	'LBWT' 'NEWLBAC' 'g' ...
	'LELB' 'LUPA' 'g' ...
	'LELB' 'NEWLSHO' 'g' ...
	'LFHD' 'LBHD' 'g' ...
	'LFRM' 'LELB' 'g' ...
	'LFWT' 'LBWT' 'g' ...
	'LFWT' 'STRN' 'g' ...
	'LHEE' 'LANK' 'g' ...
	'LKNE' 'LTHI' 'g' ...
	'LMT1' 'LANK' 'g' ...
	'LMT1' 'LMT5' 'g' ...
	'LMT5' 'LANK' 'g' ...
    'LRSTBEEF' 'LMT5' 'g' ...
    'LRSTBEEF' 'LTOE' 'g' ...
	'LTOE' 'LMT1' 'g' ...
	'LSHN' 'LKNE' 'g' ...
	'LSHO' 'C7' 'g' ...
	'LSHO' 'CLAV' 'g' ...
	'LTHI' 'LFWT' 'g' ...
	'LTHI' 'LBWT' 'g' ...
    'LFIN' 'LWRB' 'g' ...
    'LFIN' 'LTHMB' 'g' ...
	'LTHMB' 'LWRA' 'g' ...
	'LUPA' 'NEWLSHO' 'g' ...
	'LUPA' 'LSHO' 'g' ...
    'LWRA' 'LFRM' 'g' ...
    'LWRA' 'LWRB' 'g' ...
	'LWRB' 'LFRM' 'g' ...
	'NEWLBAC' 'T10' 'g' ...
	'NEWLSHO' 'LSHO' 'g' ...
... %stuff on the right:
	'RANK' 'RSHN' 'r' ...
	'RBHD' 'C7' 'r' ...
	'RBWT' 'NEWRBAC' 'r' ...
	'RELB' 'RUPA' 'r' ...
	'RELB' 'NEWRSHO' 'r' ...
	'RFHD' 'RBHD' 'r' ...
	'RFRM' 'RELB' 'r' ...
	'RFWT' 'RBWT' 'r' ...
	'RFWT' 'STRN' 'r' ...
	'RHEE' 'RANK' 'r' ...
	'RKNE' 'RTHI' 'r' ...
	'RMT1' 'RANK' 'r' ...
	'RMT1' 'RMT5' 'r' ...
	'RMT5' 'RANK' 'r' ...
    'RRSTBEEF' 'RMT5' 'r' ...
    'RRSTBEEF' 'RTOE' 'r' ...
	'RTOE' 'RMT1' 'r' ...
	'RSHN' 'RKNE' 'r' ...
	'RSHO' 'C7' 'r' ...
	'RSHO' 'CLAV' 'r' ...
	'RTHI' 'RFWT' 'r' ...
	'RTHI' 'RBWT' 'r' ...
    'RFIN' 'RWRB' 'r' ...
    'RFIN' 'RTHMB' 'r' ...
	'RTHMB' 'RWRA' 'r' ...
	'RUPA' 'NEWRSHO' 'r' ...
	'RUPA' 'RSHO' 'r' ...
    'RWRA' 'RFRM' 'r' ...
    'RWRA' 'RWRB' 'r' ...
	'RWRB' 'RFRM' 'r' ...
	'NEWRBAC' 'T10' 'r' ...
	'NEWRSHO' 'RSHO' 'r' ...
	'RBAC' 'C7' 'r' ...
	'RBAC' 'T8' 'r' ...
... %The centered stuff:	
	'C7' 'T8' 'b' ...
	'T8' 'T10' 'b' ...
	'T10' '' 'b' ...
	'LBHD' 'RBHD' 'b' ...
	'LFHD' 'RFHD' 'b' ...
	'CLAV' 'STRN' 'b' ...
	'STRN' '' 'b' ...
	};
	if nargin == 2
		for i = 1:3:size(hier,2)
			a = strcmp(hier(i), base_names);
			b = strcmp(hier(i+1), base_names);
			if (sum(a) == 1 && sum(b) == 1)
				data = [markers(a,:); markers(b,:)];
				col = [1 0 1];
				if (strcmp(hier(i+2), 'r'))
					col = [1 0 0];
				elseif (strcmp(hier(i+2), 'g'))
					col = [0 1 0];
				elseif (strcmp(hier(i+2), 'b'))
					col = [0 0 1];
				end
				line(data(:,1), data(:,2), data(:,3), 'Color', col);
			end
		end
	else
		if nargin == 3
			bound = 0.1;
		else
			bound = bound_in;
		end
		
		neutral = [0.3 0.2 0.4];
		long = [1.0 0.2 0.2];
		short = [0.8 0.8 0.3];

		%create colormap...
		cm = nan(63,3);
		for i = 1:size(cm,1)
			p = (i-1) / (size(cm,1)-1) * 2 - 1;
			if (p < 0)
				cm(i,:) = -p .* (short - neutral) + neutral;
			else
				cm(i,:) = p .* (long - neutral) + neutral;
			end
		end
		colormap(cm);
		colorbar('YTick', [1,0.5 * size(cm,1) + 1.0,size(cm,1) + 1.0], 'YTickLabel', {-bound,0.0,bound});

		for i = 1:size(bones,1)
			a = bones(i,1);
			b = bones(i,2);
			d = markers(a,:)-markers(b,:);
			d = d * d';
			d = sqrt(d) - bones(i,3);
			data = [markers(a,:); markers(b,:)];
			col = neutral;
			if d < 0
				if d < -bound
					col = short;
				else
					col = (-d / bound) .* (short - neutral) + neutral;
				end
			else
				if d > bound
					col = long;
				else
					col = (d / bound) .* (long - neutral) + neutral;
				end
			end
			line(data(:,1), data(:,2), data(:,3), 'Color', col, 'LineSmoothing', 'off');
		end
	end
end