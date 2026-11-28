#include "stm32f1xx.h"
#include "User.h"
#include "PWM.h"

int main(void) {
	SystemClock_Config(); // now its making 12 MHz
	pwm_config_tim2(); // TIM2 CH2 PWM Init
	PWM_Start();

	while(1) {

	}
}
