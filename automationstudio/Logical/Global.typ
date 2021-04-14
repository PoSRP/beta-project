
TYPE
	hmiType : STRUCT
		overrides : hmiOverrideType;	(*  *)
		fields : vFieldType;			(*  *)
		indicators : vIndicatorType;	(*  *)
		buttons : vButtonType;			(*  *)
	END_STRUCT;	
	
	hmiOverrideType : STRUCT
		acceleration : BOOL;			(*  *)
		velocity : BOOL;				(*  *)
		position : BOOL;				(*  *)
		accelerationPrevState : BOOL;	(*  *)
		velocityPrevState : BOOL;		(*  *)
		positionPrevState : BOOL;		(*  *)
		accelerationStored : REAL;		(*  *)
		velocityStored : REAL;			(*  *)
		positionStored : REAL;			(*  *)
	END_STRUCT;
	
	gControlType : STRUCT
		pidEnabled : BOOL;				(*  *)
		proportionalGain : REAL;		(*  *)
		derivativeGain : REAL;			(*  *)
		integralGain : REAL;			(*  *)
		modeVelocity : BOOL;			(*  *)
		setPosition : REAL;				(*  *)
		setDirection : BOOL;			(*  *)
		setVelocity : REAL;				(*  *)
		currentPosition : REAL;			(*  *)
		currentAngle : REAL;			(*  *)
		currentVelocity : REAL;			(*  *)
		limitAcceleration : REAL := 1000;	(*  *)
		limitVelocity : REAL := 200;	(*  *)
		limitPosPos : DINT := -5000;	(*  *)
		limitNegPos : DINT := 5000;		(*  *)
	END_STRUCT;
	
	vButtonType : STRUCT
		on : BOOL;						(*  *)
		off : BOOL;						(*  *)
		start : BOOL;					(*  *)
		stop : BOOL;					(*  *)
		ackError : BOOL;				(*  *)
		moveTypeToggle : BOOL;			(*  *)
		overrideVelocity : BOOL;		(*  *)
		overrideVelocityDir : BOOL;		(*  *)
		overridePosition : BOOL;		(*  *)
		setLimits : BOOL;				(*  *)
		setGearing : BOOL;				(*  *)
	END_STRUCT;
	
	vFieldType : STRUCT
		velocity : REAL;			(*  *)
		position : REAL;			(*  *)
		angle : REAL;				(*  *)
		ovrAcceleration : REAL;		(*  *)
		ovrVelocity : REAL;			(*  *)
		ovrPosition : REAL;			(*  *)
		accelerationLimit : REAL;	(*  *)
		velocityLimit : REAL;		(*  *)
		positionLimitNeg : DINT;	(*  *)
		positionLimitPos : DINT;	(*  *)
		controlState : WSTRING[40];	(*  *)
		errorCode : REAL;			(*  *)
		errorText : WSTRING[40];	(*  *)
	END_STRUCT;
	
	vIndicatorType : STRUCT
		modeMoveAbsolute : INT;		(*  *)
		power : INT;				(*  *)
		home : INT;					(*  *)
		stop : INT;					(*  *)
		reset : INT;				(*  *)
		moveVelocity : INT;			(*  *)
		movePosition : INT;			(*  *)
		readVelocity : INT;			(*  *)
		readPosition : INT;			(*  *)
		status : INT;				(*  *)
		error : INT;				(*  *)
		readParam : INT;			(*  *)
		writeParam : INT;			(*  *)
	END_STRUCT;
	
	opcuaReadType : STRUCT
		cartPosition : REAL := 0.0;		(* mm *)
		cartVelocity : REAL := 0.0;		(* mm/s *)
		pendulumAngle : REAL := 0.0;	(* Rad, 0 is upright position *)
	END_STRUCT;
	opcuaWriteType : STRUCT
		setCartVelocity : REAL := 0.0;	(* Negative is backward motion *)
	END_STRUCT;
	
	pviMotorType : STRUCT
		start : BOOL := FALSE;				(* Start the motor *)
		forward : BOOL := FALSE;			(* Set motor direction *)
		setVelocity : INT := 0;				(*  *)
		setConverterFrequency : INT := 0;	(*  *)
		isStarted : BOOL := FALSE;			(*  *)
		isStopped : BOOL := FALSE;			(*  *)
		isForward : BOOL := FALSE;			(*  *)
		isBackward : BOOL := FALSE;			(*  *)
		isMax : BOOL := FALSE;				(* Motor is at max limit *)
		isMiddle : BOOL := FALSE;			(* Motor is on exact middle *)
		isMin : BOOL := FALSE;				(* Motor is at min limit *)
		offsetMax : BOOL := FALSE;			(*  *)
		offsetMin : BOOL := FALSE;			(*  *)
		isReset : BOOL := FALSE;			(*  *)
		velocity : INT := 0;				(* Actual motor velocity *)
	END_STRUCT;
	
	pviType : STRUCT
		cartPositionEncoder : DINT := 0;	(* Cart position encoder output, currently in 1mm/units *)
		pendulumAngle : DINT := 0; 		(* Angle output, 1024 divisions per rotation *)
		motor : pviMotorType;		(* All motor specific variables *)
	END_STRUCT;
	
END_TYPE
