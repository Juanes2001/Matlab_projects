classdef FSU < Core.Patterns.VirtualInstrument

	methods

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	Constructor								%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function obj = FSU(varargin)
		%	Constructor of the class
		%
		%	[ input  ]
		%				Argument list, see:
		%					help Core.Patterns.VirtualInstrument
		%	[ output ]
		%				none
		%

			obj = obj@Core.Patterns.VirtualInstrument(	'Brand',			'Rohde&Schwarz', ...
														'Name',				'FSU-43', ...
														'Interface',		'TCPIP0', ...
														'Address',			'192.168.0.10', ...
														'ForceConnection',	1, ...
														varargin{:} );

		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	End of constructor						%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function init(obj)
		%	Initialise the instrument
		%
		%	[ input  ]
		%				none
		%	[ output ]
		%				none
		%
			
		end

		function delete(obj)
		%	Destructor
		%
		%	[ input  ]
		%				none
		%	[ output ]
		%				none
		%
			
		end

	end % methods
	
	methods

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	Measurements							%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function single(obj)
			
			obj.set('MEA 1');
			
		end

		function repeat(obj)
			
			obj.set('MEA 2');
			
		end

		function stop(obj)
			
			obj.set('MEA 0');
			
		end
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	Start & Stop Frequencies				%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		function setStart(obj, value)
			
			obj.set(['FREQ:STAR ' num2str(value)]);
			
		end
		
		function value = getStart(obj)
			
			value = str2double(obj.get('FREQ:STAR?'));
			
		end
		
		function setStop(obj, value)
			
			obj.set(['FREQ:STOP ' num2str(value)]);
			
		end
		
		function value = getStop(obj)
			
			value = str2double(obj.get('FREQ:STOP?'));
			
		end
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	Center & Span							%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		function setCenter(obj, value)
			
			obj.set(['FREQ:CENT ' num2str(value)]);
			
		end
		
		function value = getCenter(obj)
			
			value = str2double(obj.get('FREQ:CENT?'));
			
		end
		
		function setSpan(obj, value)
			
			obj.set(['FREQ:SPAN ' num2str(value)]);
			
		end
		
		function value = getSpan(obj)
			
			value = str2double(obj.get('FREQ:SPAN?'));
			
		end
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	Data									%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		function data = x(obj)
		%	X-axis data
		%
		%	[ input  ]
		%				none
		%	[ output ]
		%				- data		: values along the X-axis in wavelengths.
		%
		
			%	We could also use:
			%		data = obj.parse(obj.get('OSD0'));
			%	but it's faster to compute it in Matlab (and just as accurate)
			
			points = str2double(obj.get('SWEEP:POINTS?'));
			
			start = str2double(obj.get('FREQ:STAR?'));
			span = str2double(obj.get('FREQ:SPAN?'));
			
			data = start + (0:1/(points-1):1)*span;

		end

		function data = y(obj, channel)
		%	Y-axis data
		%
		%	[ input  ]
		%				none
		%	[ output ]
		%				- data	: values along the Y-axis.
		%
		
			if ~exist('channel', 'var') || ~isnumeric(channel) || isempty(channel) || isnan(channel)
				channel = 1;
			end
		
			data = obj.parse(obj.get(['TRAC? TRACE' num2str(channel)]));
		
		end
		
	end

end