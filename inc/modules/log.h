#include <stdarg.h>

namespace log {
	enum LOG_LEVEL{
		LL_ERROR,
		LL_WARN,
		LL_INFO,
		LL_DEBUG,
	};

	extern int (* $_log)(const char *fmt, ...);
	extern int (* $_vlog)(const char *fmt, va_list va);

	static inline void $fg_rgb(int rgb) {
		$_log("\033[38;2;%d;%d;%dm",
				(rgb >> 16) & 0xff, (rgb >> 8) & 0xff, (rgb >> 0) & 0xff);
	}

	static inline void $bg_rgb(int rgb) {
		$_log("\033[48;2;%d;%d;%dm",
				(rgb >> 16) & 0xff, (rgb >> 8) & 0xff, (rgb >> 0) & 0xff);
	}

	static inline void $reset_color() {
		$_log("\033[0m");
	}

	void set_level(enum LOG_LEVEL level);
	void debug(const char *fmt, ...);
	void info(const char *fmt, ...);
	void warn(const char *fmt, ...);
	void error(const char *fmt, ...);
	void trace(const char *fmt, ...);
};

#define $debug(fmt, ...) log::debug("(%s:%d): " fmt, __FILE__, __LINE__, ##__VA_ARGS__)
#define $info(fmt, ...)  log::info("(%s:%d): " fmt, __FILE__, __LINE__, ##__VA_ARGS__)
#define $warn(fmt, ...)  log::warn("(%s:%d): " fmt, __FILE__, __LINE__, ##__VA_ARGS__)
#define $error(fmt, ...) log::error("(%s:%d): " fmt, __FILE__, __LINE__, ##__VA_ARGS__)
#define $xx              log::trace("(%s:%d): %s", __FILE__, __LINE__, __func__)
