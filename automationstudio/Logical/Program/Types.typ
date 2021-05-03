TYPE
	controlStateEnum : (
		CTRL_INIT,
		CTRL_HOME_START,
		CTRL_HOME_SEEK_NEG,
		CTRL_HOME_SEEK_POS,
		CTRL_HOME_CENTER,
		CTRL_STOP,
		CTRL_RUNNING,
		CTRL_NO_SIM,
		CTRL_NO_CONTROLLER
	);
	
	opcuaType : STRUCT 			(* For OPCUA *)
		cartPosition : REAL := 0.0;		(* mm *)
		cartVelocity : REAL := 0.0;		(* mm/s *)
		pendulumAngle : REAL := 0.0;	(* Rad, 0 is upright position *)
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
		motor : pviMotorType;			(* All motor specific variables *)
	END_STRUCT;
	
	controlType : STRUCT
		state : controlStateEnum;		(*  *)
		setVelocity : REAL;				(*  *)
		currentPosition : REAL;			(*  *)
		currentAngle : REAL;			(*  *)
		currentVelocity : REAL;			(*  *)
		currentDirection : BOOL;		(*  *)
		limitAcceleration : REAL := 1000;	(*  *)
		limitVelocity : REAL := 200;	(*  *)
		limitPosPos : DINT := -5000;	(*  *)
		limitNegPos : DINT := 5000;		(*  *)
		homing : homingType;		(*  *)
	END_STRUCT;
	
	localPidType : STRUCT
		velocity : REAL := 4000;		(*  *)
	END_STRUCT;
	
	homingType : STRUCT
		foundNegLim : REAL;				(*  *)
		foundPosLim : REAL;				(*  *)
		seekVelocity : REAL := 500;		(*  *)
		middleVelocity : REAL := 1500;	(*  *)
	END_STRUCT;
	
	hmiType : STRUCT
		fields : hmiFieldType;			(*  *)
		indicators : hmiIndicatorType;	(*  *)
		buttons : hmiButtonType;			(*  *)

	END_STRUCT;	
	
	hmiButtonType : STRUCT
		start : BOOL;					(*  *)
		startPrevious : BOOL;
		localPid : BOOL;				(*  *)
		localPidPrevious : BOOL;
		simulinkPid : BOOL;				(*  *)
		simulinkPidPrevious : BOOL;
		experiorSim : BOOL;				(*  *)
		experiorSimPrevious : BOOL;
		simulinkSim : BOOL;				(*  *)
		simulinkSimPrevious : BOOL;
	END_STRUCT;

	hmiFieldType : STRUCT
		velocity : REAL;			(*  *)
		position : REAL;			(*  *)
		angle : REAL;				(*  *)
		ovrPosition : REAL;			(*  *)
		accelerationLimit : REAL;		(*  *)
		velocityLimit : REAL;			(*  *)
		positionLimitNeg : REAL;		(*  *)
		positionLimitPos : REAL;		(*  *)
		controlState : WSTRING[40];		(*  *)
	END_STRUCT;

	hmiIndicatorType : STRUCT
		pvi : BOOL; 	(*  *)
		opcua : BOOL;	(*  *)
	END_STRUCT;
	
END_TYPE