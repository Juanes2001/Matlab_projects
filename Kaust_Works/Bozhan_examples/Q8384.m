classdef Q8384 < Core.Patterns.VirtualInstrument

	methods

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	Constructor								%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function obj = Q8384(varargin)
		%	Constructor of the class
		%
		%	[ input  ]
		%				Argument list, see:
		%					help Core.Patterns.VirtualInstrument
		%	[ output ]
		%				none
		%

			obj = obj@Core.Patterns.VirtualInstrument(	'Brand',			'ADVANTEST', ...
														'Name',				'Q8384', ...
														'Interface',		'GPIB0', ...
														'Address',			8, ...
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
			%	Make sure we don't return the header with each comand
			obj.set('HED 0');
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
			
			obj.set(['STA ' num2str(value*1E-9)]);
			
		end
		
		function value = getStart(obj)
			
			value = str2double(obj.get('STA?'))*1E9;
			
		end
		
		function setStop(obj, value)
			
			obj.set(['STO ' num2str(value*1E-9)]);
			
		end
		
		function value = getStop(obj)
			
			value = str2double(obj.get('STO?'))*1E9;
			
		end
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	Center & Span							%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		function setCenter(obj, value)
			
			obj.set(['CEN ' num2str(value*1E-9)]);
			
		end
		
		function value = getCenter(obj)
			
			value = str2double(obj.get('CEN?'))*1E9;
			
		end
		
		function setSpan(obj, value)
			
			obj.set(['SPA ' num2str(value)]);
			
		end
		
		function value = getSpan(obj)
			
			value = str2double(obj.get('SPA?'))*1E9;
			
		end
		
		function setMode(obj, value)
			
			set(obj, ['SWE ' num2str(value)]);
			
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
			
			points = str2double(obj.get('ODN?'));
			
			start = str2double(obj.get('STA?'));
			span = str2double(obj.get('SPA?'));
			
			data = (start + (0:1/(points-1):1)*span)*1E9;

		end

		function data = y(obj)
		%	Y-axis data
		%
		%	[ input  ]
		%				none
		%	[ output ]
		%				- data	: values along the Y-axis.
		%
		
			data = obj.parse(obj.get('OSD0'));
		
		end
		
	end

end