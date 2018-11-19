void CPUperformanceUpdate() {
  for (Method method : operatingSystemMXBean.getClass().getDeclaredMethods()) {
    method.setAccessible(true);
    if (method.getName().startsWith("get") && Modifier.isPublic(method.getModifiers())) {
      Object value;
      try {
        value = method.invoke(operatingSystemMXBean);
      } 
      catch (Exception e) {
        value = e;
      } 
      //System.out.println(method.getName() + " = " + value);
      if (method.getName() == "getProcessCpuLoad") {
        fill(255);
        CPUperform = nfc(float(value.toString())*100, 3);
      }
    }
  }
}
