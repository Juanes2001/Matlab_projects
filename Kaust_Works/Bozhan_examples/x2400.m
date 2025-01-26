classdef x2400 < Core.Patterns.VirtualInstrument
	
	properties (Access=protected)
		
		Scale = 1;
		
	end

	methods

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	Constructor								%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function obj = x2400(varargin)
		%	Constructor of the class
		%
		%	[ input  ]
		%				Argument list, see:
		%					help Core.Patterns.VirtualInstrument
		%	[ output ]
		%				none
		%

			obj = obj@Core.Patterns.VirtualInstrument(	'Brand',			'KEITHLEY INSTRUMENTS INC.', ...
														'Name',				'MODEL 2400', ...
														'Interface',		'GPIB0', ...
														'Address',			6, ...
														'ForceConnection ',	1, ...
														varargin{:} );

		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%	End of constructor						%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function delete(obj)
		%	Destructor
		%
		%	[ input  ]
		%				none
		%	[ output ]
		%				none
		%
		
			%	This function is executed before disconnecting the instrument
			%	Send commands using obj.set

		end

	end % methods

	methods
		
		function value = invert(obj)
			
			obj.Scale = -obj.Scale;
			value = obj.Scale;
			
		end

		function useFrontSource(obj)
		
			set(obj, ':ROUT:TERM FRONT');
			
		end

		function useRearSource(obj)
		
			set(obj, ':ROUT:TERM REAR');
			
		end

		function useVoltageSource(obj)
		
			set(obj, ':SOUR:FUNC VOLT');
			
		end

		function useCurrentSource(obj)
		
			set(obj, ':SOUR:FUNC CURR');
			
		end

		function enable(obj)
		
			set(obj, ':OUTPUT ON');
			
		end

		function disable(obj)
		
			set(obj, ':OUTPUT OFF');
			
		end
		
		function setVoltage(obj, value)
		
			set(obj, [':SOUR:VOLT ' num2str(value*obj.Scale)]);
			
		end
		
		function setVoltageCompliance(obj, value)
		
			set(obj, [':SENS:VOLT:PROT ' num2str(value)]);
			
		end
		
		function setCurrent(obj, value)
		
			%	Assume the current value is in mA as a safety
			set(obj, [':SOUR:CURR ' num2str(value*obj.Scale*1E-3)]);
			
		end
		
		function setCurrentCompliance(obj, value)
		
			%	Assume the current value is in mA as a safety
			set(obj, [':SENS:CURR:PROT ' num2str(value*1E-3)]);
			
		end
		
		function setVoltageRange(obj, value)
		
			if exist('value', 'var') && value
				obj.set('SENS:VOLT:RANGE:AUTO 0');
				obj.set('SOUR:VOLT:RANGE:AUTO 0');
				
				obj.set(['SOUR:VOLT:RANGE ' num2str(value)]);
				obj.set(['SENS:VOLT:RANGE ' num2str(value)]);
			else
				obj.set('SENS:VOLT:RANGE:AUTO 1');
				obj.set('SOUR:VOLT:RANGE:AUTO 1');
			end
			
		end
		
		function setCurrentRange(obj, value)
		
			if exist('value', 'var') && value
				%	Assume the current value is in mA as a safety
				value = value*1E-3;
			
				obj.set('SENS:CURR:RANGE:AUTO 0');
				obj.set('SOUR:CURR:RANGE:AUTO 0');
				
				obj.set(['SOUR:CURR:RANGE ' num2str(value)]);
				obj.set(['SENS:CURR:RANGE ' num2str(value)]);
			else
				obj.set('SENS:CURR:RANGE:AUTO 1');
				obj.set('SOUR:CURR:RANGE:AUTO 1');
			end
			
		end
		
		function data = getData(obj)
			
			data = parse(obj, get(obj, ':READ?'));
			
		end
		
		function value = readVoltage(obj)
			
			data = obj.getData();
			value = data(1)*obj.Scale;
			
		end
		
		function value = readCurrent(obj)
			
			%	Return the current value in mA
			data = obj.getData();
			value = data(2)*obj.Scale*1E3;
			
		end
		
		function value = getVoltage(obj)
			
			data = parse(obj, get(obj, ':MEAS:VOLT?'));
			value = data(1)*obj.Scale;
			
		end
		
		function value = getCurrent(obj)
			
			%	Return the current value in mA
			data = parse(obj, get(obj, ':MEAS:CURR?'));
			value = data(2)*obj.Scale*1E3;
			
		end

	end % methods

end