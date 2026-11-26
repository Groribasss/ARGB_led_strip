#include "stm32f1xx.h"
#include "User.h"
#include "PWM.h"

int main(void) {
	SystemClock_Config();
	pwm_config_tim2();
	PWM_Start();

	while(1) {

	}
}