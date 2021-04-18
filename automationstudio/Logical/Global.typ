
TYPE
	ctrlStateEnum : 
		(
		CTRL_INIT,
		CTRL_OFF,
		CTRL_POWER_ON_AXIS,
		CTRL_POWERING_ON_AXIS,
		CTRL_POWER_OFF_AXIS,
		CTRL_POWERING_OFF_AXIS,
		CTRL_HOME_AXIS,
		CTRL_HOMING_AXIS,
		CTRL_STOPPING,
		CTRL_STANDSTILL,
		CTRL_MOVE_VELOCITY,
		CTRL_MOVE_ABSOLUTE,
		CTRL_ERROR,
		CTRL_MOVE_VELOCITY_ERROR,
		CTRL_MOVE_ABSOLUTE_ERROR,
		CTRL_FATAL_ERROR,
		CTRL_FATAL_ERROR_EXIT
	);
	
	mcBlocksType : STRUCT
		power : MC_Power;
		home : MC_Home;
		stop : MC_Stop;
		reset : MC_Reset;
		moveVelocity : MC_MoveVelocity;
		moveAbsolute : MC_MoveAbsolute;
		currentPosition : MC_ReadActualPosition;
		currentVelocity : MC_ReadActualVelocity;
		status : MC_ReadStatus;
		error : MC_ReadAxisError;
	END_STRUCT;
	
	gLocalPID : STRUCT
		enabled : BOOL;					(*  *)
		proportionalGain : BOOL;		(*  *)
		integralGain : BOOL;			(*  *)
		derivativeGain : BOOL;			(*  *)
	END_STRUCT;
	
	gControlType : STRUCT
		localPID : gLocalPID;			(*  *)
		modeVelocity : BOOL;			(*  *)
		setPosition : REAL;				(*  *)
		setDirection : BOOL;			(*  *)
		setVelocity : REAL;				(*  *)
		currentPosition : REAL;			(*  *)
		currentAngle : REAL;			(*  *)
		currentVelocity : REAL;			(*  *)
		currentDirection : INT;			(*  *)
		limitAcceleration : REAL := 1000;	(*  *)
		limitVelocity : REAL := 200;	(*  *)
		limitPosPos : DINT := -5000;	(*  *)
		limitNegPos : DINT := 5000;		(*  *)
	END_STRUCT;
	
	hmiType : STRUCT
		fields : vFieldType;			(*  *)
		indicators : vIndicatorType;	(*  *)
		buttons : vButtonType;			(*  *)
	END_STRUCT;	
	
	vButtonType : STRUCT
		on : BOOL;						(*  *)
		onPrevious : BOOL;
		off : BOOL;						(*  *)
		offPrevious : BOOL;
		start : BOOL;					(*  *)
		startPrevious : BOOL;
		stop : BOOL;					(*  *)
		stopPrevious : BOOL;
		localPid : BOOL;				(*  *)
		localPidPrevious : BOOL;
		simulinkPid : BOOL;				(*  *)
		simulinkPidPrevious : BOOL;
		externalSim : BOOL;				(*  *)
		externalSimPrevious : BOOL;
		simulinkSim : BOOL;				(*  *)
		simulinkSimPrevious : BOOL;
		ackError : BOOL;				(*  *)
		ackErrorPrevious : BOOL;
		overridePosition : BOOL;		(*  *)
		overridePositionPrevious : BOOL;
	END_STRUCT;
	
	vFieldType : STRUCT
		velocity : REAL;			(*  *)
		position : REAL;			(*  *)
		angle : REAL;				(*  *)
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
	
	opcuaWriteType : STRUCT 			(* For variables read from OPCUA *)
		cartPosition : REAL := 0.0;		(* mm *)
		cartVelocity : REAL := 0.0;		(* mm/s *)
		pendulumAngle : REAL := 0.0;	(* Rad, 0 is upright position *)
	END_STRUCT;
	opcuaReadType : STRUCT 				(* For variables written to OPCUA *)
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
