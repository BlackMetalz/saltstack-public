Here's an example of how to use the improved [`redis_check.py`] plugin:

### Usage Examples

1. **Check Memory Usage:**
   ```sh
   ./redis_check.py -p 6800 -t memory -w 80 -c 90
   ```

   This command checks the memory usage of the Redis instance running on port 6800. It will warn if memory usage exceeds 80% and will be critical if it exceeds 90%.

   It does has the timeout in case of redis port is telnet or success in enten redis-cli but freeze.

2. **Check Role:**
   ```sh
   ./redis_check.py -p 6800 -t role -role master
   ```

   This command checks if the Redis instance running on port 6800 is a master. It will be critical if the role is not master.

3. **Check Both Memory and Role:**
   ```sh
   ./redis_check.py -p 6800 -t both -w 80 -c 90 -role master
   ```

   This command checks both the memory usage and the role of the Redis instance running on port 6800. It will warn if memory usage exceeds 80%, be critical if it exceeds 90%, and also be critical if the role is not master.

### Command Line Arguments

- `-p`: Redis port to monitor (required).
- `-i`: Redis IP (default is `127.0.0.1`).
- `-a`: Redis port's password (optional, will be read from `/opt/redis-auth.json` if not provided).
- `-w`: Warning threshold for memory usage (default is 80%).
- `-c`: Critical threshold for memory usage (default is 90%).
- `-t`: Type of check (memory, role, or both) (required).
- `-role`: Expected role (master or slave) (required if -t is role or both).

### Example Output

1. **Memory Check:**
   ```sh
   ./redis_check.py -p 6800 -t memory -w 80 -c 90
   ```

   Output:
   ```
   Ok! Port 6800 used 45% memory
   ```

2. **Role Check:**
   ```sh
   ./redis_check.py -p 6800 -t role -role master
   ```

   Output:
   ```
   Ok! Role is master
   ```

3. **Both Checks:**
   ```sh
   ./redis_check.py -p 6800 -t both -w 80 -c 90 -role master
   ```

   Output:
   ```
   Ok! Port 6800 used 45% memory Ok! Role is master
   ```

These examples demonstrate how to use the plugin to monitor Redis instances for memory usage and role status.