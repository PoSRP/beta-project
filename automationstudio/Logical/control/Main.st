
PROGRAM _INIT
	(* Insert code here *)
	
END_PROGRAM

PROGRAM _CYCLIC
	CASE ctrlState OF
		CTRL_INIT:
			// Binding the motion axis to MC blocks
			mc.home.Axis := ADR(gAxis);
			mc.moveAbsolute.Axis := ADR(gAxis);
			mc.moveVelocity.Axis := ADR(gAxis);
			mc.power.Axis := ADR(gAxis);
			mc.reset.Axis := ADR(gAxis);
			mc.stop.Axis := ADR(gAxis);
			mc.currentPosition.Axis := ADR(gAxis);
			mc.currentVelocity.Axis := ADR(gAxis);
			mc.error.Axis := ADR(gAxis);
		
			// Next state
			ctrlState := CTRL_OFF;
			
		CTRL_OFF:
			// Check if ON is requested and change state
			IF hmi.buttons.on THEN
				ctrlState := CTRL_POWER_ON_AXIS;
			END_IF
			
		CTRL_POWER_ON_AXIS:
			// Enable the block required for std operation
			mc.power.Enable := TRUE;
			mc.currentPosition.Enable := TRUE;
			mc.currentVelocity.Enable := TRUE;
			mc.error.Enable := TRUE;
			mc.status.Enable := TRUE;
			
			// Change state
			ctrlState := CTRL_POWERING_ON_AXIS;
			
		CTRL_POWERING_ON_AXIS:
			// Change state if Power is on
			// TODO: Include checks for the other blocks? 
			IF mc.power.Status THEN
				ctrlState := CTRL_HOME_AXIS;
			END_IF
			
		CTRL_POWER_OFF_AXIS:
			// Disable the blocks used for std operation
			mc.power.Enable := FALSE;
			mc.currentPosition.Enable := FALSE;
			mc.currentVelocity.Enable := FALSE;
			mc.error.Enable := FALSE;
			mc.status.Enable := FALSE;
			
			// Change state
			ctrlState := CTRL_POWERING_OFF_AXIS;
			
		CTRL_POWERING_OFF_AXIS:
			// Change state when block are off
			IF NOT mc.power.Status AND NOT mc.currentPosition.Valid AND NOT mc.currentVelocity.Valid THEN
				ctrlState := CTRL_OFF;
			END_IF
			
		CTRL_HOME_AXIS:
			// If Execute is true, flip and come back next cycle
			IF mc.home.Execute THEN
				mc.home.Execute := FALSE;
			ELSE
				// Start homing and change state
				mc.home.Execute := TRUE;
				ctrlState := CTRL_HOMING_AXIS;
			END_IF
			
			
		CTRL_HOMING_AXIS:
			// Change state when homing is done
			IF mc.home.Done THEN
				mc.home.Execute := FALSE;
				ctrlState := CTRL_STOPPING;
			END_IF
			
		CTRL_STOPPING:
			// Change state when confirmed stopped
			mc.stop.Execute := TRUE;
			IF mc.stop.Done THEN
				mc.stop.Execute := FALSE;
				ctrlState := CTRL_STANDSTILL;
			END_IF
			
		CTRL_STANDSTILL:
			// Wait for something to start the operation
			IF hmi.buttons.start OR hmi.buttons.overridePosition THEN
				// Reset the button
				hmi.buttons.start := FALSE;
				// If the override move position is active, do that
				IF hmi.buttons.overridePosition THEN
					// Set the move position from the field
					gControl.setPosition := hmi.fields.ovrPosition;
					// Reset the button
					hmi.buttons.overridePosition := FALSE;
					// Change to move absolute state
					ctrlState := CTRL_MOVE_ABSOLUTE;
				ELSE
					// 'Normal' velocity based operation
					ctrlState := CTRL_MOVE_VELOCITY;
				END_IF
			ELSIF hmi.buttons.off THEN
				// Power off if button has been pushed
				hmi.buttons.off := FALSE;
				ctrlState := CTRL_POWER_OFF_AXIS;
			END_IF
			
		CTRL_MOVE_VELOCITY:
			// Check if a stop or manual position override is requested
			IF hmi.buttons.stop OR hmi.buttons.overridePosition THEN
				// Reset button
				hmi.buttons.stop := FALSE;
				// Stop velocity block and change to stop state
				mc.moveVelocity.Execute := FALSE;
				ctrlState := CTRL_STOPPING;
			ELSE
				// Check that velocity requested is within limits
				IF gControl.setVelocity >= 0 AND gControl.setVelocity < gControl.limitVelocity THEN
					// Update move block velocity
					mc.moveVelocity.Velocity := gControl.setVelocity;
					// Set direction
					IF gControl.setDirection THEN
						mc.moveVelocity.Direction := mcPOSITIVE_DIR;
					ELSE
						mc.moveVelocity.Direction := mcNEGATIVE_DIR;
					END_IF
					
					// Toggle execute and update the block to allow for changes in same cycle
					IF mc.moveVelocity.Execute THEN
						mc.moveVelocity.Execute := FALSE;
						mc.moveVelocity();
					END_IF
					// Start executing move
					mc.moveVelocity.Execute := TRUE;
				ELSE
					// Limits not met, stop motion
					mc.moveVelocity.Velocity := 0;
					mc.moveVelocity.Execute := FALSE;
					ctrlState := CTRL_STOPPING;
				END_IF
			END_IF
			
		CTRL_MOVE_ABSOLUTE:
			// This move mode is used for the override position only
			IF hmi.buttons.stop THEN
				// Reset the button
				hmi.buttons.stop := FALSE;
				// Stop moving
				mc.moveAbsolute.Execute := FALSE;
				ctrlState := CTRL_STOPPING;
			ELSIF mc.moveAbsolute.Done THEN
				// Movement complete, go to standstill state
				mc.moveAbsolute.Execute := FALSE;
				ctrlState := CTRL_STANDSTILL;
			ELSE
				// Check if move is needed (within 0.1 unit of current position)
				IF ABS(gControl.currentPosition - gControl.setPosition) > 0.1 THEN
					// Set new position in block
					mc.moveAbsolute.Position := gControl.setPosition;
					// Start execution
					mc.moveAbsolute.Execute := TRUE;
				ELSIF NOT mc.moveAbsolute.Execute THEN
					// Move not big enough, go to standstill state
					// If block is already active we might just be very close and don't want to do anything
					mc.moveAbsolute.Execute := FALSE;
					ctrlState := CTRL_STANDSTILL;
				END_IF
			END_IF
						
		CTRL_ERROR:
			
		CTRL_FATAL_ERROR:
			
		CTRL_FATAL_ERROR_EXIT:
		
	END_CASE
	
	// Updating blocks, minus info-only blocks (see varUpdates loop)
	mc.home();
	mc.moveAbsolute();
	mc.moveVelocity();
	mc.power();
	mc.reset();
	mc.stop();
	
	// Error checking
	// TODO: Do something 
	IF mc.home.Error THEN
	END_IF
	IF mc.moveAbsolute.Error THEN
	END_IF
	IF mc.moveVelocity.Error THEN
	END_IF
	IF mc.power.Error THEN
	END_IF
	IF mc.reset.Error THEN
	END_IF
	IF mc.stop.Error THEN
	END_IF
	IF mc.currentPosition.Error THEN
	END_IF
	IF mc.currentVelocity.Error THEN
	END_IF
	IF mc.status.Error THEN
	END_IF
	
	pvi.pendulumAngle;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

