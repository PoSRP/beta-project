
TYPE
	hmiType : STRUCT
		overrides : hmiOverrideType;
		fields : vFieldType;
		indicators : vIndicatorType;
		buttons : vButtonType;
	END_STRUCT;
	
	hmiOverrideType : STRUCT
		acceleration : BOOL;
		velocity : BOOL;
		position : BOOL;
		accelerationPrevState : BOOL;
		velocityPrevState : BOOL;
		positionPrevState : BOOL;
		accelerationStored : REAL;
		velocityStored : REAL;
		positionStored : REAL;
	END_STRUCT;
	
	gControlType : STRUCT
		pidEnabled : BOOL;
		proportionalGain : REAL;
		derivativeGain : REAL;
		integralGain : REAL;
		modeVelocity : BOOL;
		setPosition : REAL;
		setDirection : BOOL;
		setVelocity : REAL;
		currentPosition : REAL;
		currentAngle : REAL;
		currentVelocity : REAL;
		limitAcceleration : REAL := 1000;
		limitVelocity : REAL := 200;
		limitPosPos : DINT := -5000;
		limitNegPos : DINT := 5000;
	END_STRUCT;
	
	vButtonType : STRUCT
		on : BOOL;
		off : BOOL;
		start : BOOL;
		stop : BOOL;
		ackError : BOOL;
		moveTypeToggle : BOOL;
		overrideVelocity : BOOL;
		overrideVelocityDir : BOOL;
		overridePosition : BOOL;
		setLimits : BOOL;
		setGearing : BOOL;
	END_STRUCT;
	
	vFieldType : STRUCT
		velocity : REAL;
		position : REAL;
		angle : REAL;
		ovrAcceleration : REAL;
		ovrVelocity : REAL;
		ovrPosition : REAL;
		accelerationLimit : REAL;
		velocityLimit : REAL;
		positionLimitNeg : DINT;
		positionLimitPos : DINT;
		controlState : WSTRING[40];
		errorCode : REAL;
		errorText : WSTRING[40];
	END_STRUCT;
	
	vIndicatorType : STRUCT
		modeMoveAbsolute : INT;
		power : INT;
		home : INT;
		stop : INT;
		reset : INT;
		moveVelocity : INT;
		movePosition : INT;
		readVelocity : INT;
		readPosition : INT;
		status : INT;
		error : INT;
		readParam : INT;
		writeParam : INT;
	END_STRUCT;
END_TYPE
