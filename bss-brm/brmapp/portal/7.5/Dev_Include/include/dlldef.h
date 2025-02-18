/* Use this file as follows
 *
 * To export function or data from a DLL:
 *   #define DLL_SPEC (BUILDING_xxx_EXPORT == 1)
 *   #include <dlldef.h>
 *   PUBLIC int mydllfunc(int x);
 *   extern PUBLIC int mydlldata;
 *
 * To export a function or data which is NOT in a DLL:
 *   #define DLL_LOCAL
 *   #include <dlldef.h>
 *   PUBLIC int mylocalfunc(int x);
 *   extern PUBLIC int mylocaldata;
 */

#undef PUBLIC

#if !defined(WIN32)
  /* Unix is easy */
  #define PUBLIC
#else
  /* Windows is complex */
  #if defined(DLL_LOCAL) || !defined(DO_DLL_DECL)
    #define PUBLIC
  #else
    #if DLL_SPEC
      #define PUBLIC __declspec(dllexport)
    #else
      #define PUBLIC __declspec(dllimport)
    #endif
  #endif
#endif

#undef DLL_SPEC
#undef DLL_LOCAL
